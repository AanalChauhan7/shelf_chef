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
  // Query-parameter names for GET /recipes. Match these to the parameters
  // listed under GET /recipes in the Swagger docs (/docs). Unknown query
  // parameters are ignored by the server, so a mismatch is harmless.
  static const String _servingsParam = 'servings';
  static const String _languageParam = 'language';

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
    Duration timeout = const Duration(seconds: 45),
  }) async {
    final res = await ApiClient.request(
      'GET',
      '/recipes',
      query: {
        if (servings != null) _servingsParam: '$servings',
        if (language != null) _languageParam: language,
      },
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
    final pantry = await PantryApiService.fetchPantryItems();
    final ingredients = pantry
        .where((p) => !p.isExpired)
        .map((p) => IngredientItem(
              id: p.id,
              name: p.name,
              quantity: p.quantity,
              unit: p.unit,
            ))
        .toList();
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

  /// Saves [recipe] and returns it carrying its new server id.
  ///
  /// If the server answers 422 (validation error) the body is adjusted to the
  /// fields it complains about and sent again, up to a few times.
  static Future<GeneratedRecipe> saveRecipe(GeneratedRecipe recipe) async {
    final payload = SavedRecipePayload(recipe);
    ApiResponse? res;
    for (var attempt = 0; attempt < 5; attempt++) {
      res = await ApiClient.request(
        'POST',
        '/saved-recipes',
        body: payload.fields,
      );
      if (res == null || res.statusCode != 422) break;
      if (!payload.adaptTo(res.data)) break;
    }
    final body = _requireOk(res, 'save the recipe');

    String? id;
    if (body is Map) {
      final nested = body['recipe'] is Map ? body['recipe'] as Map : const {};
      id = (body['id'] ?? body['recipe_id'] ?? nested['id'])?.toString();
    }
    if (id != null) return recipe.withId(id);

    // The server didn't echo an id: look the recipe up in the saved list.
    final saved = await fetchSavedRecipes();
    final match = saved.where((r) => r.name == recipe.name && r.id != null);
    return recipe.withId(match.isEmpty ? null : match.last.id);
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
  }) {
    const groups = [
      ['gujarati'],
      ['indian'],
      ['global', 'international', 'world', 'continental'],
    ];
    final picked = <GeneratedRecipe>[];
    for (final words in groups) {
      final candidates = all
          .where((r) =>
              !picked.contains(r) &&
              words.any(r.category.toLowerCase().contains))
          .toList();
      if (candidates.isNotEmpty) {
        picked.add(candidates[offset % candidates.length]);
      }
    }
    for (final r in all) {
      if (picked.length >= 3) break;
      if (!picked.contains(r)) picked.add(r);
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
