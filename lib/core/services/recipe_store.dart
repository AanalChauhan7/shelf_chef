import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/recipes/models/generated_recipe.dart';
import 'app_language_service.dart';
import 'recipe_api_service.dart';

/// App-wide holder for the pantry-based recipe suggestions (`GET /recipes`)
/// and the user's saved recipes (`GET /saved-recipes`).
///
/// Both the home card and the Recipes tab read from here, so:
/// - suggestions are fetched ONCE (kept in memory and on disk) and reused;
/// - they are fetched again only when [refreshSuggested] is called, i.e. when
///   the user taps the reload button on the Recipes tab.
class RecipeStore extends ChangeNotifier {
  RecipeStore._();
  static final RecipeStore instance = RecipeStore._();

  static const String _cacheKey = 'recipe_suggestions_cache_v1';

  List<GeneratedRecipe> _suggested = const [];
  List<GeneratedRecipe> _saved = const [];
  bool _suggestedLoaded = false;
  bool _suggestedLoading = false;
  bool _offline = false; // suggestions are on-device, not from the API
  String? _suggestedError;
  String? _savedError;
  int _fetchCount = 0; // rotates the picks on every reload
  int _featuredIndex = 0; // which suggestion the home card shows

  bool _savedLoaded = false;
  bool _savedLoading = false;

  List<GeneratedRecipe> get suggested => _suggested;
  List<GeneratedRecipe> get saved => _saved;
  bool get suggestedLoaded => _suggestedLoaded;
  bool get suggestedLoading => _suggestedLoading;
  bool get suggestedOffline => _offline;
  String? get suggestedError => _suggestedError;

  bool get savedLoaded => _savedLoaded;
  bool get savedLoading => _savedLoading;
  String? get savedError => _savedError;

  /// The one recipe shown on the home card: one of the (up to three) current
  /// suggestions, or null while there are none. See [shuffleFeatured].
  GeneratedRecipe? get featured =>
      _suggested.isEmpty ? null : _suggested[_featuredIndex % _suggested.length];

  GeneratedRecipe? get featuredRecipe => featured;

  /// Shows a different suggestion on the home card (no network call).
  void shuffleFeatured() {
    if (_suggested.length < 2) return;
    _pickFeatured();
    notifyListeners();
  }

  void rotateFeatured() => shuffleFeatured();

  /// Random index, never the one already showing (when there is a choice).
  void _pickFeatured() {
    if (_suggested.isEmpty) return;
    final current = _featuredIndex % _suggested.length;
    var next = Random().nextInt(_suggested.length);
    if (_suggested.length > 1 && next == current) {
      next = (next + 1) % _suggested.length;
    }
    _featuredIndex = next;
  }

  // --- Suggestions ---

  /// Loads suggestions only if we have none yet: first from the on-disk
  /// cache, then from the API. Does nothing when recipes are already loaded.
  Future<void> ensureSuggested({
    required int servings,
    required String language,
  }) async {
    if (_suggestedLoaded || _suggestedLoading) return;
    final cached = await _readCache();
    if (_suggestedLoaded || _suggestedLoading) return;
    if (cached.isNotEmpty) {
      _suggested = cached
          .map((r) => AppLanguageService.translateRecipe(r, language))
          .toList();
      _fetchCount = 1; // the cache came from a first fetch
      _suggestedLoaded = true;
      _offline = false;
      _applySaved();
      _pickFeatured();
      notifyListeners();
      unawaited(loadSaved(silent: true));
      return;
    }
    await refreshSuggested(servings: servings, language: language);
  }

  /// Always asks the API for new suggestions (the reload button).
  ///
  /// Returns true when fresh recipes arrived from the API. If the API fails
  /// and API recipes were already showing, they are kept.
  Future<bool> refreshSuggested({
    required int servings,
    required String language,
  }) async {
    if (_suggestedLoading) return false;
    _suggestedLoading = true;
    _suggestedError = null;
    notifyListeners();

    var fresh = false;
    final offset = _fetchCount++;
    final savedFuture = _fetchSavedQuietly();
    try {
      final recipes = await RecipeApiService.fetchRecipes(
        servings: servings,
        language: language,
      );
      final saved = await savedFuture;
      if (saved != null) {
        _saved = saved;
        _savedLoaded = true;
      }
      // One Gujarati, one Indian and one Global recipe.
      final top = RecipeApiService.topThreeByCategory(recipes, offset: offset);
      final localizedTop = top
          .map((r) => AppLanguageService.translateRecipe(r, language))
          .toList();

      _suggested = localizedTop;
      _suggestedLoaded = true;
      _offline = false;
      _applySaved();
      _pickFeatured();
      fresh = true;
      unawaited(_writeCache(localizedTop));
    } on RecipeApiException catch (e) {
      if (_suggestedLoaded && !_offline) {
        _suggestedError = e.message; // keep the previous API recipes
      } else {
        await _useOfflineSuggestions(servings, language, e.message);
      }
    } finally {
      _suggestedLoading = false;
      notifyListeners();
    }
    return fresh;
  }

  Future<void> _useOfflineSuggestions(
    int servings,
    String language,
    String error,
  ) async {
    final offline = await RecipeApiService.fetchOfflineSuggestions(
      servings: servings,
      language: language,
    );
    if (offline.isEmpty) {
      _suggestedError = error;
      return;
    }
    _suggested = offline
        .map((r) => AppLanguageService.translateRecipe(r, language))
        .toList();
    _suggestedLoaded = true;
    _offline = true;
    _applySaved();
    _pickFeatured();
  }

  // --- Saved recipes ---

  Future<void> loadSaved({bool silent = false}) async {
    if (!silent) {
      _savedLoading = true;
      _savedError = null;
      notifyListeners();
    }
    try {
      _saved = await RecipeApiService.fetchSavedRecipes();
      _savedLoaded = true;
      _applySaved();
    } on RecipeApiException catch (e) {
      if (!silent) _savedError = e.message;
    } finally {
      if (!silent) _savedLoading = false;
      notifyListeners();
    }
  }

  /// Call after a recipe is saved or un-saved from the detail dialog.
  void onSavedChanged(GeneratedRecipe recipe) {
    _saved = _saved.where((s) => s.name != recipe.name).toList();
    if (recipe.isSaved) _saved = [recipe, ..._saved];
    _applySaved();
    notifyListeners();
  }

  Future<List<GeneratedRecipe>?> _fetchSavedQuietly() async {
    try {
      return await RecipeApiService.fetchSavedRecipes();
    } on RecipeApiException {
      return null;
    }
  }

  /// Marks suggestions as saved when a saved recipe has the same name.
  void _applySaved() {
    _suggested = _suggested.map((recipe) {
      final match = _saved.where((s) => s.name == recipe.name && s.id != null);
      return recipe.withId(match.isEmpty ? null : match.first.id);
    }).toList();
  }

  // --- On-disk cache (API results only; offline stand-ins are never cached) ---

  Future<List<GeneratedRecipe>> _readCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return const [];
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return list
          .whereType<Map>()
          .map((m) => GeneratedRecipe.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _writeCache(List<GeneratedRecipe> recipes) async {
    if (recipes.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = recipes
          .map((r) => {...r.toApiJson(), 'matchPercent': r.matchPercent})
          .toList();
      await prefs.setString(_cacheKey, jsonEncode(json));
    } catch (_) {
      // Caching is best-effort.
    }
  }
}
