import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/recipes/models/generated_recipe.dart';
import 'app_language_service.dart';
import 'recipe_api_service.dart';
import 'shopping_api_service.dart';

/// App-wide holder for the pantry-based recipe suggestions (`GET /recipes`)
/// and the user's saved recipes (`GET /saved-recipes`).
///
/// Both the home card and the Recipes tab read from here, so:
/// - suggestions are fetched ONCE (kept in memory and on disk) and reused;
/// - they are fetched again only when [refreshSuggested] is called, i.e. when
///   the user explicitly taps the reload button on the Recipes tab.
class RecipeStore extends ChangeNotifier {
  RecipeStore._();
  static final RecipeStore instance = RecipeStore._();

  static const String _cacheKey = 'recipe_suggestions_cache_v2';
  static const String _savedCacheKey = 'saved_recipes_local_cache_v2';

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
  /// cache, then from the API. Does nothing when recipes are already loaded
  /// so that switching tabs never reloads or loses recipes.
  Future<void> ensureSuggested({
    required int servings,
    required String language,
  }) async {
    // If recipes are already in memory, keep them intact!
    if (_suggested.isNotEmpty) return;
    if (_suggestedLoading) return;

    await _initSavedFromDisk();

    final cached = await _readCache();
    if (_suggested.isNotEmpty) return;
    if (cached.isNotEmpty) {
      _suggested = cached
          .map((r) => AppLanguageService.translateRecipe(r, language))
          .toList();
      _fetchCount = 1;
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

  /// Always asks for fresh suggestions when the user taps reload at the top.
  ///
  /// Returns true when fresh recipes arrived from the API.
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
    unawaited(loadSaved(silent: true));
    try {
      final recipes = await RecipeApiService.fetchRecipes(
        servings: servings,
        language: language,
        timeout: const Duration(seconds: 50),
      );

      if (recipes.isEmpty) {
        throw const RecipeApiException(
          'Your pantry is empty or the chef could not find matching recipes. '
          'Add items to your pantry and tap reload.',
        );
      }

      // Pick one Gujarati, one Indian and one Global recipe directly from the API.
      final top = RecipeApiService.topThreeByCategory(
        recipes,
        offset: offset,
        language: language,
        servings: servings,
      );
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
      _suggestedError = e.message;
    } catch (e) {
      _suggestedError = e.toString();
    } finally {
      _suggestedLoading = false;
      notifyListeners();
    }
    return fresh;
  }

  // --- Saved recipes (with persistent local disk storage) ---

  Future<void> _initSavedFromDisk() async {
    if (_savedLoaded && _saved.isNotEmpty) return;
    final cached = await _readSavedCache();
    if (cached.isNotEmpty) {
      _saved = cached;
      _savedLoaded = true;
      _applySaved();
      notifyListeners();
    }
  }

  /// Checks if [recipe] is currently saved locally or on the server.
  bool isRecipeSaved(GeneratedRecipe recipe) {
    final targetName = recipe.name.trim().toLowerCase();
    return _saved.any((s) =>
        s.name.trim().toLowerCase() == targetName ||
        (recipe.id != null && recipe.id!.isNotEmpty && s.id == recipe.id));
  }

  /// Toggles saved state for [recipe] purely in local disk storage
  /// (no API calls) with instant persistence and immediate UI reflection.
  Future<GeneratedRecipe> toggleSaveRecipe(GeneratedRecipe recipe) async {
    await _initSavedFromDisk();
    final currentlySaved = isRecipeSaved(recipe);

    if (currentlySaved) {
      final match = _saved.firstWhere(
        (s) =>
            s.name.trim().toLowerCase() == recipe.name.trim().toLowerCase() ||
            (recipe.id != null && s.id == recipe.id),
        orElse: () => recipe,
      );
      final idToDelete = match.id ?? recipe.id;

      _saved = _saved
          .where((s) =>
              s.name.trim().toLowerCase() != recipe.name.trim().toLowerCase() &&
              (s.id == null || s.id != idToDelete))
          .toList();
      _applySaved();
      await _writeSavedCache(_saved);
      notifyListeners();
      return recipe.withId(null);
    } else {
      final localId = recipe.id ??
          'local_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
      final savedRecipe = recipe.withId(localId);

      _saved = [
        savedRecipe,
        ..._saved.where(
          (s) => s.name.trim().toLowerCase() != savedRecipe.name.trim().toLowerCase(),
        ),
      ];
      _applySaved();
      await _writeSavedCache(_saved);
      notifyListeners();

      // When a recipe is saved, add any missing ingredients to the shopping cart
      unawaited(
        ShoppingApiService.addMissingIngredientsFromRecipe(recipe)
            .catchError((_) => 0),
      );

      return savedRecipe;
    }
  }

  /// Loads saved recipes purely from local disk storage (no API call).
  Future<void> loadSaved({bool silent = false}) async {
    if (!silent && !_savedLoaded) {
      _savedLoading = true;
      _savedError = null;
      notifyListeners();
    }

    final cached = await _readSavedCache();
    _saved = cached;
    _savedLoaded = true;
    _savedLoading = false;
    _applySaved();
    notifyListeners();
  }

  /// Call after a recipe is saved or un-saved.
  void onSavedChanged(GeneratedRecipe recipe) {
    if (recipe.isSaved) {
      final exists = _saved.any(
        (s) => s.name.trim().toLowerCase() == recipe.name.trim().toLowerCase(),
      );
      if (!exists) {
        _saved = [recipe, ..._saved];
      } else {
        _saved = _saved
            .map((s) => s.name.trim().toLowerCase() == recipe.name.trim().toLowerCase()
                ? recipe
                : s)
            .toList();
      }
    } else {
      _saved = _saved
          .where((s) =>
              s.name.trim().toLowerCase() != recipe.name.trim().toLowerCase() &&
              (recipe.id == null || s.id != recipe.id))
          .toList();
    }
    _applySaved();
    unawaited(_writeSavedCache(_saved));
    notifyListeners();
  }

  /// Marks suggestions as saved when a saved recipe has the same name.
  void _applySaved() {
    _suggested = _suggested.map((recipe) {
      final match = _saved.where(
        (s) => s.name.trim().toLowerCase() == recipe.name.trim().toLowerCase(),
      );
      if (match.isNotEmpty) {
        return recipe.withId(match.first.id ?? 'saved');
      } else {
        return recipe.withId(null);
      }
    }).toList();
  }

  // --- On-disk caches ---

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
      final json = recipes.map((r) => r.toJson()).toList();
      await prefs.setString(_cacheKey, jsonEncode(json));
    } catch (_) {
      // Caching is best-effort.
    }
  }

  Future<List<GeneratedRecipe>> _readSavedCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_savedCacheKey);
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

  Future<void> _writeSavedCache(List<GeneratedRecipe> recipes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = recipes.map((r) => r.toJson()).toList();
      await prefs.setString(_savedCacheKey, jsonEncode(json));
    } catch (_) {
      // Caching is best-effort.
    }
  }
}
