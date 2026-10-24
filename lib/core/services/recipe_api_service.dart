import '../../features/recipes/models/generated_recipe.dart';
import '../../features/recipes/models/ingredient_item.dart';
import 'api_client.dart';
import 'pantry_api_service.dart';
import 'recipe_fallback_engine.dart';
import 'saved_recipe_payload.dart';

/// Thrown when a recipe API call fails; [message] is safe to show to users.
class RecipeApiException implements Exception {
  final String message;
  const RecipeApiException(this.message);

  @override
  String toString() => message;
}

/// Smart Pantry recipe endpoints:
///
/// - `GET    /recipes`                  recipes suggested from the pantry
/// - `GET    /saved-recipes`            the user's saved recipes
/// - `POST   /saved-recipes`            save a recipe
/// - `GET    /saved-recipes/{recipe_id}` one saved recipe
/// - `DELETE /saved-recipes/{recipe_id}` remove a saved recipe
class RecipeApiService {
  static const List<String> _listKeys = [
    'recipes',
    'saved_recipes',
    'data',
    'items',
    'results',
    'value',
  ];

  /// Recipe suggestions based on what's in the pantry.
  static Future<List<GeneratedRecipe>> fetchRecipes({
    int? servings,
    String? language,
    Duration timeout = const Duration(seconds: 50),
  }) async {
    final res = await ApiClient.request(
      'GET',
      '/recipes',
      timeout: timeout,
    );
    return _parseList(_requireOk(res, 'load recipes'));
  }

  /// Offline suggestions built from the pantry, for when `GET /recipes`
  /// doesn't answer. These are NOT from the API.
  static Future<List<GeneratedRecipe>> fetchOfflineSuggestions({
    required int servings,
    required String language,
  }) async {
    List<IngredientItem> ingredients = const [];
    try {
      final pantry = await PantryApiService.fetchPantryItems()
          .timeout(const Duration(seconds: 4));
      ingredients = pantry
          .where((p) => !p.isExpired)
          .map((p) => IngredientItem(
                id: p.id,
                name: p.name,
                quantity: p.quantity,
                unit: p.unit,
              ))
          .toList();
    } catch (_) {
      // Best-effort: if pantry API fails or times out, fallback recipes are still generated.
      ingredients = const [];
    }
    return RecipeFallbackEngine.getFallbackRecipes(
      ingredients,
      servings,
      language,
    );
  }

  /// All recipes the user has saved.
  static Future<List<GeneratedRecipe>> fetchSavedRecipes() async {
    final res = await ApiClient.request('GET', '/saved-recipes');
    return _parseList(_requireOk(res, 'load saved recipes'));
  }

  /// A single saved recipe by its server id.
  static Future<GeneratedRecipe> fetchSavedRecipe(String recipeId) async {
    final res = await ApiClient.request(
      'GET',
      '/saved-recipes/${Uri.encodeComponent(recipeId)}',
    );
    final body = _requireOk(res, 'load the recipe');
    if (body is Map) {
      return GeneratedRecipe.fromJson(Map<String, dynamic>.from(body));
    }
    throw const RecipeApiException('Unexpected response for this recipe.');
  }

  /// Saves [recipe] using `POST /saved-recipes` with `{ "recipe": "<name>" }`.
  static Future<GeneratedRecipe> saveRecipe(GeneratedRecipe recipe) async {
    ApiResponse? res = await ApiClient.request(
      'POST',
      '/saved-recipes',
      body: {'recipe': recipe.name},
      timeout: const Duration(seconds: 45),
    );

    if (res != null && res.statusCode == 422) {
      final payload = SavedRecipePayload(recipe);
      for (var attempt = 0; attempt < 3; attempt++) {
        if (!payload.adaptTo(res?.data)) break;
        res = await ApiClient.request(
          'POST',
          '/saved-recipes',
          body: payload.fields,
          timeout: const Duration(seconds: 45),
        );
        if (res == null || res.statusCode != 422) break;
      }
    }

    final body = _requireOk(res, 'save the recipe');

    String? id;
    if (body is Map) {
      final nested = body['recipe'] is Map ? body['recipe'] as Map : const {};
      id = (body['id'] ?? body['recipe_id'] ?? nested['id'])?.toString();
    }
    if (id != null) return recipe.withId(id);

    // The server didn't echo an id: look the recipe up in the saved list.
    try {
      final saved = await fetchSavedRecipes();
      final match = saved.where(
        (r) => r.name.toLowerCase() == recipe.name.toLowerCase() && r.id != null,
      );
      if (match.isNotEmpty) return recipe.withId(match.last.id);
    } catch (_) {}

    return recipe;
  }

  /// Removes a saved recipe.
  static Future<void> deleteSavedRecipe(String recipeId) async {
    final res = await ApiClient.request(
      'DELETE',
      '/saved-recipes/${Uri.encodeComponent(recipeId)}',
    );
    _requireOk(res, 'remove the recipe');
  }

  /// Picks one Gujarati, one Indian and one Global recipe (in that order),
  /// topping up with any remaining recipes if a category is missing.
  ///
  /// [offset] rotates through the recipes of each category, so repeated
  /// reloads can surface different dishes when the API returns more than one
  /// per category.
  static List<GeneratedRecipe> topThreeByCategory(
    List<GeneratedRecipe> all, {
    int offset = 0,
    String language = 'English',
    int servings = 2,
  }) {
    const groups = [
      [
        'gujarati',
        'ગુજરાતી',
        'गुजराती',
        'dhokla',
        'khichdi',
        'thepla',
        'handvo',
        'undhiyu',
        'sev tameta',
        'rotli',
        'kadhi',
      ],
      [
        'indian',
        'ભારતીય',
        'भारतीय',
        'paneer',
        'dal',
        'curry',
        'biryani',
        'chole',
        'rajma',
        'masala',
        'roti',
        'paratha',
      ],
      [
        'global',
        'international',
        'world',
        'continental',
        'ગ્લોબલ',
        'ઇન્ટરનેશનલ',
        'ग्लोबल',
        'इंटरनेशनल',
        'pasta',
        'pizza',
        'noodles',
        'salad',
        'tacos',
        'soup',
        'stir-fry',
        'burger',
        'sandwich',
      ],
    ];
    final picked = <GeneratedRecipe>[];
    for (final words in groups) {
      final candidates = all
          .where((r) =>
              !picked.contains(r) &&
              (words.any(r.category.toLowerCase().contains) ||
               words.any(r.name.toLowerCase().contains)))
          .toList();
      if (candidates.isNotEmpty) {
        picked.add(candidates[offset % candidates.length]);
      }
    }
    for (final r in all) {
      if (picked.length >= 3) break;
      if (!picked.contains(r)) picked.add(r);
    }

    // If all is empty (e.g. offline testing), provide fallbacks
    if (all.isEmpty && picked.length < 3) {
      final fallbacks = RecipeFallbackEngine.getFallbackRecipes([], servings, language);
      for (final fb in fallbacks) {
        if (picked.length >= 3) break;
        final hasCat = picked.any((p) => p.category.toLowerCase() == fb.category.toLowerCase());
        if (!hasCat) {
          picked.add(fb);
        }
      }
      for (final fb in fallbacks) {
        if (picked.length >= 3) break;
        if (!picked.contains(fb)) {
          picked.add(fb);
        }
      }
    }

    return picked;
  }

  // --- Helpers ---

  static dynamic _requireOk(ApiResponse? res, String action) {
    if (res == null) {
      throw RecipeApiException(
        "Couldn't $action. Check your connection — the server may be waking "
        'up, so try again in a moment.',
      );
    }
    if (!res.ok) {
      final reason = res.statusCode == 422
          ? SavedRecipePayload.describe(res.data)
          : '';
      throw RecipeApiException(
        "Couldn't $action (server error ${res.statusCode})"
        '${reason.isEmpty ? '.' : ': $reason'}',
      );
    }
    return res.data;
  }

  static List<GeneratedRecipe> _parseList(dynamic body) {
    final raw = ApiClient.extractList(body, _listKeys);
    final items = raw.isEmpty && body is Map && _looksLikeRecipe(body)
        ? [body]
        : raw;
    return items
        .whereType<Map>()
        .map((m) => GeneratedRecipe.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  static bool _looksLikeRecipe(Map body) =>
      body.containsKey('name') || body.containsKey('title');
}
