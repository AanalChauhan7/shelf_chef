import '../../../core/services/recipe_image_service.dart';

/// Single ingredient detail item with quantity and source type.
class RecipeIngredientDetail {
  final String name;
  final String quantity;
  final String type; // 'available', 'assumed', 'missing'

  const RecipeIngredientDetail({
    required this.name,
    required this.quantity,
    this.type = 'available',
  });

  String get displayString => quantity.isNotEmpty ? '$name — $quantity' : name;

  factory RecipeIngredientDetail.fromJson(
    Map<String, dynamic> json, {
    String type = 'available',
  }) {
    return RecipeIngredientDetail(
      name: json['name']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
      type: type,
    );
  }
}

/// Single step detail item with duration and instruction.
class RecipeStepDetail {
  final int stepNumber;
  final String instruction;
  final int durationMinutes;

  const RecipeStepDetail({
    required this.stepNumber,
    required this.instruction,
    this.durationMinutes = 0,
  });

  factory RecipeStepDetail.fromJson(Map<String, dynamic> json) {
    return RecipeStepDetail(
      stepNumber: json['stepNumber'] is int
          ? json['stepNumber'] as int
          : int.tryParse(json['stepNumber']?.toString() ?? '1') ?? 1,
      instruction: json['instruction']?.toString() ?? '',
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes'] as int
          : int.tryParse(json['durationMinutes']?.toString() ?? '0') ?? 0,
    );
  }
}

/// Model representing a detailed AI generated recipe.
class GeneratedRecipe {
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

  factory GeneratedRecipe.fromJson(Map<String, dynamic> json) {
    final titleName =
        json['name']?.toString() ??
        json['title']?.toString() ??
        'AI Special Recipe';

    List<RecipeIngredientDetail> parseIngs(dynamic raw, String type) {
      if (raw is List) {
        return raw.map((e) {
          if (e is Map<String, dynamic>) {
            return RecipeIngredientDetail.fromJson(e, type: type);
          }
          return RecipeIngredientDetail(
            name: e.toString(),
            quantity: '',
            type: type,
          );
        }).toList();
      }
      return [];
    }

    final available = parseIngs(
      json['availableIngredients'] ?? json['ingredientsUsed'],
      'available',
    );
    final assumed = parseIngs(json['assumedStaples'], 'assumed');
    final missing = parseIngs(json['missingIngredients'], 'missing');

    List<RecipeStepDetail> parsedSteps = [];
    if (json['steps'] is List) {
      parsedSteps = (json['steps'] as List).map((e) {
        if (e is Map<String, dynamic>) return RecipeStepDetail.fromJson(e);
        return RecipeStepDetail(
          stepNumber: parsedSteps.length + 1,
          instruction: e.toString(),
        );
      }).toList();
    } else if (json['instructions'] is List) {
      int idx = 1;
      parsedSteps = (json['instructions'] as List)
          .map(
            (e) =>
                RecipeStepDetail(stepNumber: idx++, instruction: e.toString()),
          )
          .toList();
    }

    final prep = json['prepTimeMinutes'] is int
        ? json['prepTimeMinutes'] as int
        : int.tryParse(json['prepTimeMinutes']?.toString() ?? '15') ?? 15;
    final cook = json['cookTimeMinutes'] is int
        ? json['cookTimeMinutes'] as int
        : int.tryParse(json['cookTimeMinutes']?.toString() ?? '15') ?? 15;
    final total = json['totalTimeMinutes'] is int
        ? json['totalTimeMinutes'] as int
        : (prep + cook);
    final cal = json['caloriesPerServing'] is int
        ? json['caloriesPerServing'] as int
        : int.tryParse(json['caloriesPerServing']?.toString() ?? '350') ?? 350;

    return GeneratedRecipe(
      category: json['category']?.toString() ?? 'Gujarati',
      name: titleName,
      description: json['description']?.toString() ?? 'Delicious AI recipe.',
      servings: json['servings'] is int ? json['servings'] as int : 2,
      prepTimeMinutes: prep,
      cookTimeMinutes: cook,
      totalTimeMinutes: total,
      difficulty: json['difficulty']?.toString() ?? 'Medium',
      caloriesPerServing: cal,
      availableIngredients: available,
      assumedStaples: assumed,
      missingIngredients: missing,
      steps: parsedSteps,
      chefTip: json['chefTip']?.toString() ?? '',
      matchPercent: json['matchPercent']?.toString() ?? '95%',
      imageUrl: json['imageUrl']?.toString(),
    );
  }
}
