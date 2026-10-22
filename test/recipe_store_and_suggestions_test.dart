import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_chef_app/core/services/recipe_api_service.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('topThreeByCategory guaranteed 3 recipes', () {
    test('returns 3 recipes (Gujarati, Indian, Global) even when input is empty', () {
      final recipes = RecipeApiService.topThreeByCategory(
        [],
        language: 'English',
        servings: 2,
      );

      expect(recipes.length, 3);
      expect(recipes.any((r) => r.category.toLowerCase().contains('gujarati')), isTrue);
      expect(recipes.any((r) => r.category.toLowerCase().contains('indian')), isTrue);
      expect(recipes.any((r) => r.category.toLowerCase().contains('global')), isTrue);
    });

    test('matches Gujarati and Hindi categories properly', () {
      final all = [
        const GeneratedRecipe(
          category: 'ગુજરાતી',
          name: 'કાઠિયાવાડી ઢોકળા',
          description: 'સ્વાદિષ્ટ ઢોકળા',
        ),
        const GeneratedRecipe(
          category: 'भारतीय',
          name: 'पनीर बटर मसाला',
          description: 'मसालेदार पनीर',
        ),
        const GeneratedRecipe(
          category: 'Continental',
          name: 'Veggie Pasta',
          description: 'Cheesy pasta',
        ),
      ];

      final recipes = RecipeApiService.topThreeByCategory(
        all,
        language: 'Gujarati',
        servings: 2,
      );

      expect(recipes.length, 3);
      expect(recipes[0].name, 'કાઠિયાવાડી ઢોકળા');
      expect(recipes[1].name, 'पनीर बटर मसाला');
      expect(recipes[2].name, 'Veggie Pasta');
    });
  });

  group('Smart Pantry API parsing', () {
    test('parses real GET /recipes response correctly', () {
      final json = {
        "name": "Aloo Tomato Nu Shaak",
        "category": "Gujarati",
        "cuisine": "Gujarati",
        "cook_time": "30 mins",
        "servings": 2,
        "match": 85,
        "difficulty": "Easy",
        "reason": "A classic everyday Gujarati potato and tomato curry made using your main pantry staples.",
        "ingredients": [
          {
            "name": "Potatoes",
            "required_quantity": 400,
            "unit": "g",
            "status": "Available"
          },
          {
            "name": "Tomatoes",
            "required_quantity": 300,
            "unit": "g",
            "status": "Available"
          },
          {
            "name": "cooking oil",
            "required_quantity": 2,
            "unit": "tbsp",
            "status": "Staple"
          }
        ],
        "id": 1
      };

      final recipe = GeneratedRecipe.fromJson(json);
      expect(recipe.id, "1");
      expect(recipe.name, "Aloo Tomato Nu Shaak");
      expect(recipe.category, "Gujarati");
      expect(recipe.description, contains("everyday Gujarati potato"));
      expect(recipe.totalTimeMinutes, 30);
      expect(recipe.matchPercent, "85%");
      expect(recipe.availableIngredients.length, 2);
      expect(recipe.availableIngredients.first.name, "Potatoes");
      expect(recipe.availableIngredients.first.quantity, "400 g");
      expect(recipe.assumedStaples.length, 1);
      expect(recipe.assumedStaples.first.name, "cooking oil");
    });

    test('parses real GET /saved-recipes response correctly', () {
      final json = {
        "id": 1,
        "name": "Classic Gujarati Sev Tamatar",
        "category": "Main Course",
        "overview": "A vibrant and comforting Gujarati classic.",
        "cook_time": "25 minutes",
        "servings": 2,
        "instructions": [
          "Chop the tomatoes finely.",
          "Heat cooking oil in a pan over medium heat."
        ],
        "nutrition": {
          "calories": "280 kcal"
        },
        "tips": [
          "Always add the Ratlami Sev right at the end."
        ]
      };

      final recipe = GeneratedRecipe.fromJson(json);
      expect(recipe.id, "1");
      expect(recipe.name, "Classic Gujarati Sev Tamatar");
      expect(recipe.description, "A vibrant and comforting Gujarati classic.");
      expect(recipe.totalTimeMinutes, 25);
      expect(recipe.steps.length, 2);
      expect(recipe.steps.first.instruction, "Chop the tomatoes finely.");
      expect(recipe.caloriesPerServing, 280);
      expect(recipe.chefTip, contains("Ratlami Sev"));
    });
  });
}
