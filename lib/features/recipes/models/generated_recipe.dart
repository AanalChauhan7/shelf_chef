import '../../../core/services/recipe_image_service.dart';
import 'recipe_parts.dart';

export 'recipe_parts.dart';

/// Model representing a detailed recipe (AI generated or from the API).
class GeneratedRecipe {
  /// Server id. Only set for recipes stored via `/saved-recipes`.
  final String? id;
  final String category;
  final String name;
  final String description;
  final int servings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int totalTimeMinutes;
  final String difficulty;
  final int caloriesPerServing;
  final List<RecipeIngredientDetail> availableIngredients;
  final List<RecipeIngredientDetail> assumedStaples;
  final List<RecipeIngredientDetail> missingIngredients;
  final List<RecipeStepDetail> steps;
  final String chefTip;
  final String matchPercent;
  final String? imageUrl;

  const GeneratedRecipe({
    this.id,
    required this.category,
    required this.name,
    required this.description,
    this.servings = 2,
    this.prepTimeMinutes = 15,
    this.cookTimeMinutes = 15,
    this.totalTimeMinutes = 30,
    this.difficulty = 'Medium',
    this.caloriesPerServing = 350,
    this.availableIngredients = const [],
    this.assumedStaples = const [],
    this.missingIngredients = const [],
    this.steps = const [],
    this.chefTip = '',
    this.matchPercent = '95%',
    this.imageUrl,
  });

  // Legacy/UI Compatibility Getters
  String get title => name;
  String get prepTime => '$totalTimeMinutes mins';
  String get calories => '$caloriesPerServing kcal';
  bool get isSaved => id != null;

  List<RecipeIngredientDetail> get allIngredientDetails => [
    ...availableIngredients,
    ...assumedStaples,
    ...missingIngredients,
  ];

  List<String> get ingredientsUsed =>
      allIngredientDetails.map((e) => e.displayString).toList();

  List<String> get instructions => steps.map((s) => s.instruction).toList();

  String get displayImageUrl =>
      RecipeImageService.getRecipeImageUrl(name, providedUrl: imageUrl);

  /// Copy of this recipe carrying (or clearing) the saved-recipe [id].
  GeneratedRecipe withId(String? newId) => _copy(id: newId);

  /// Copy with a different [category] and/or [matchPercent] (id is kept).
  GeneratedRecipe copyWith({String? category, String? matchPercent}) =>
      _copy(id: id, category: category, matchPercent: matchPercent);

  GeneratedRecipe _copy({
    required String? id,
    String? category,
    String? matchPercent,
  }) => GeneratedRecipe(
    id: id,
    category: category ?? this.category,
    name: name,
    description: description,
    servings: servings,
    prepTimeMinutes: prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes,
    totalTimeMinutes: totalTimeMinutes,
    difficulty: difficulty,
    caloriesPerServing: caloriesPerServing,
    availableIngredients: availableIngredients,
    assumedStaples: assumedStaples,
    missingIngredients: missingIngredients,
    steps: steps,
    chefTip: chefTip,
    matchPercent: matchPercent ?? this.matchPercent,
    imageUrl: imageUrl,
  );

  /// Body sent to `POST /saved-recipes`.
  Map<String, dynamic> toApiJson() => {
    'name': name,
    'title': name,
    'category': category,
    'description': description,
    'servings': servings,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'totalTimeMinutes': totalTimeMinutes,
    'difficulty': difficulty,
    'caloriesPerServing': caloriesPerServing,
    'availableIngredients': availableIngredients.map((e) => e.toJson()).toList(),
    'assumedStaples': assumedStaples.map((e) => e.toJson()).toList(),
    'missingIngredients': missingIngredients.map((e) => e.toJson()).toList(),
    'steps': steps.map((e) => e.toJson()).toList(),
    'chefTip': chefTip,
    'imageUrl': imageUrl,
  };

  /// Complete JSON representation for local persistence/caching.
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'name': name,
    'title': name,
    'category': category,
    'description': description,
    'servings': servings,
    'prepTimeMinutes': prepTimeMinutes,
    'cookTimeMinutes': cookTimeMinutes,
    'totalTimeMinutes': totalTimeMinutes,
    'difficulty': difficulty,
    'caloriesPerServing': caloriesPerServing,
    'availableIngredients': availableIngredients.map((e) => e.toJson()).toList(),
    'assumedStaples': assumedStaples.map((e) => e.toJson()).toList(),
    'missingIngredients': missingIngredients.map((e) => e.toJson()).toList(),
    'steps': steps.map((e) => e.toJson()).toList(),
    'chefTip': chefTip,
    'matchPercent': matchPercent,
    'imageUrl': imageUrl,
  };

  /// Accepts the Gemini schema, the Smart Pantry API schema, or a saved
  /// recipe wrapper such as `{ "id": 3, "recipe": { ... } }`.
  factory GeneratedRecipe.fromJson(Map<String, dynamic> json) {
    var data = json;
    for (final wrapper in ['recipe', 'recipe_data', 'data']) {
      if (json[wrapper] is Map) {
        data = {...json, ...Map<String, dynamic>.from(json[wrapper] as Map)};
        break;
      }
    }

    final pick = RecipeJson.pick;

    List<RecipeIngredientDetail> available = [];
    List<RecipeIngredientDetail> assumed = [];
    List<RecipeIngredientDetail> missing = [];

    final rawIngredients = data['ingredients'];
    if (rawIngredients is List && rawIngredients.isNotEmpty) {
      for (final item in rawIngredients) {
        if (item is Map) {
          final status = item['status']?.toString().toLowerCase() ?? '';
          if (status == 'staple') {
            assumed.add(
              RecipeIngredientDetail.fromJson(
                Map<String, dynamic>.from(item),
                type: 'assumed',
              ),
            );
          } else if (status == 'missing') {
            missing.add(
              RecipeIngredientDetail.fromJson(
                Map<String, dynamic>.from(item),
                type: 'missing',
              ),
            );
          } else {
            available.add(
              RecipeIngredientDetail.fromJson(
                Map<String, dynamic>.from(item),
                type: 'available',
              ),
            );
          }
        } else {
          available.add(
            RecipeIngredientDetail(
              name: item.toString(),
              quantity: '',
              type: 'available',
            ),
          );
        }
      }
    } else {
      available = RecipeJson.ingredients(
        pick(data, [
          'availableIngredients',
          'available_ingredients',
          'ingredientsUsed',
        ]),
        'available',
      );
      assumed = RecipeJson.ingredients(
        pick(data, ['assumedStaples', 'assumed_staples']),
        'assumed',
      );
      missing = RecipeJson.ingredients(
        pick(data, ['missingIngredients', 'missing_ingredients']),
        'missing',
      );
    }

    if (assumed.isEmpty && data['staple_ingredients'] is List) {
      assumed = RecipeJson.ingredients(data['staple_ingredients'], 'assumed');
    }
    if (missing.isEmpty && data['missing_ingredients'] is List) {
      missing = RecipeJson.ingredients(data['missing_ingredients'], 'missing');
    }

    final prep = RecipeJson.toInt(
          pick(data, ['prepTimeMinutes', 'prep_time_minutes', 'prep_time']),
        ) ??
        10;
    final cook = RecipeJson.toInt(
          pick(data, [
            'cookTimeMinutes',
            'cook_time_minutes',
            'cook_time',
            'cookTime',
          ]),
        ) ??
        20;
    final total = RecipeJson.toInt(
          pick(data, [
            'totalTimeMinutes',
            'total_time_minutes',
            'total_time',
            'time',
            'cook_time',
            'cookTime',
          ]),
        ) ??
        (prep + cook);

    final matchRaw = pick(data, [
      'matchPercent',
      'match_percent',
      'match_percentage',
      'match',
    ]);
    final rawId = json['id'] ?? json['recipe_id'] ?? json['_id'];

    final nutrition = data['nutrition'] is Map ? data['nutrition'] as Map : null;
    final caloriesRaw = pick(data, [
          'caloriesPerServing',
          'calories_per_serving',
          'calories',
        ]) ??
        nutrition?['calories'];
    final calories = RecipeJson.toInt(caloriesRaw) ?? 350;

    final tipRaw = pick(data, ['chefTip', 'chef_tip', 'tip']);
    final tip = tipRaw != null
        ? RecipeJson.text(tipRaw)
        : (data['tips'] is List && (data['tips'] as List).isNotEmpty
            ? (data['tips'] as List).first.toString()
            : '');

    return GeneratedRecipe(
      id: rawId?.toString(),
      category: RecipeJson.text(
        pick(data, ['category', 'cuisine', 'type']) ?? 'Recipe',
      ),
      name: RecipeJson.text(
        pick(data, ['name', 'title', 'recipe_name']) ?? 'Chef Special',
      ),
      description: RecipeJson.text(
        pick(data, ['description', 'summary', 'reason', 'overview']) ??
            'Delicious recipe.',
      ),
      servings: RecipeJson.toInt(pick(data, ['servings', 'serves'])) ?? 2,
      prepTimeMinutes: prep,
      cookTimeMinutes: cook,
      totalTimeMinutes: total,
      difficulty: RecipeJson.text(data['difficulty'] ?? 'Medium'),
      caloriesPerServing: calories,
      availableIngredients: available,
      assumedStaples: assumed,
      missingIngredients: missing,
      steps: RecipeJson.steps(
        pick(data, ['steps', 'instructions', 'directions', 'method']),
      ),
      chefTip: tip,
      matchPercent: RecipeJson.match(matchRaw),
      imageUrl: pick(data, ['imageUrl', 'image_url', 'image', 'thumbnail'])
          ?.toString(),
    );
  }
}
