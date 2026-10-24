import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_chef_app/core/services/app_language_service.dart';
import 'package:shelf_chef_app/core/services/gemini_recipe_service.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';
import 'package:shelf_chef_app/features/recipes/models/ingredient_item.dart';

void main() {
  group('Recipe Language and Translation Tests', () {
    test('AppLanguageService provides correct labels and tags', () {
      expect(AppLanguageService.getLanguageTag('Gujarati'), 'gu-IN');
      expect(AppLanguageService.getLanguageTag('Hindi'), 'hi-IN');
      expect(AppLanguageService.getLanguageTag('English'), 'en-US');

      expect(AppLanguageService.tr('generate_recipe', 'Gujarati'), 'એઆઈ રેસિપી બનાવો');
      expect(AppLanguageService.tr('generate_recipe', 'Hindi'), 'एआई रेसिपी बनाएं');
      expect(AppLanguageService.tr('generate_recipe', 'English'), 'Generate AI Recipe');

      expect(AppLanguageService.tr('search_ai', 'Gujarati'), 'એઆઈ સાથે રેસિપી શોધો');
      expect(AppLanguageService.tr('search_ai', 'Hindi'), 'एआई के साथ रेसिपी खोजें');
    });

    test('GeminiRecipeService generates recipes in Gujarati for Rice & Wheat Flour', () async {
      final ingredients = [
        const IngredientItem(id: '1', name: 'Rice', quantity: '5', unit: 'kg'),
        const IngredientItem(id: '2', name: 'Wheat Flour', quantity: '5', unit: 'kg'),
      ];

      final recipes = await GeminiRecipeService.generateRecipes(
        ingredients: ingredients,
        peopleCount: 2,
        preferredLanguage: 'Gujarati',
      );

      expect(recipes.length, 3);
      for (final recipe in recipes) {
        expect(AppLanguageService.hasGujarati(recipe.name), isTrue,
            reason: 'Recipe name "${recipe.name}" should contain Gujarati text');
        expect(AppLanguageService.hasGujarati(recipe.description), isTrue,
            reason: 'Recipe description should contain Gujarati text');
        expect(recipe.steps.isNotEmpty, isTrue,
            reason: 'Recipe should have cooking steps');
        expect(AppLanguageService.hasGujarati(recipe.steps.first.instruction), isTrue,
            reason: 'Steps should be in Gujarati');
      }
    });

    test('GeminiRecipeService generates recipes in Hindi for Rice & Wheat Flour', () async {
      final ingredients = [
        const IngredientItem(id: '1', name: 'Rice', quantity: '5', unit: 'kg'),
        const IngredientItem(id: '2', name: 'Wheat Flour', quantity: '5', unit: 'kg'),
      ];

      final recipes = await GeminiRecipeService.generateRecipes(
        ingredients: ingredients,
        peopleCount: 2,
        preferredLanguage: 'Hindi',
      );

      expect(recipes.length, 3);
      for (final recipe in recipes) {
        expect(AppLanguageService.hasHindi(recipe.name), isTrue,
            reason: 'Recipe name "${recipe.name}" should contain Hindi text');
        expect(AppLanguageService.hasHindi(recipe.description), isTrue,
            reason: 'Recipe description should contain Hindi text');
        expect(recipe.steps.isNotEmpty, isTrue,
            reason: 'Recipe should have cooking steps');
        expect(AppLanguageService.hasHindi(recipe.steps.first.instruction), isTrue,
            reason: 'Steps should be in Hindi');
      }
    });

    test('AppLanguageService translates English API recipes into Gujarati and Hindi', () {
      const englishRecipe = GeneratedRecipe(
        category: 'Gujarati',
        name: 'Sev Tomato Nu Shaak',
        description: 'A classic Gujarati sabzi made primarily with tomatoes from your pantry.',
        availableIngredients: [
          RecipeIngredientDetail(name: 'Tomato', quantity: '500 g'),
          RecipeIngredientDetail(name: 'Onion', quantity: '1 kg'),
        ],
        steps: [],
      );

      final gujaratiRecipe = AppLanguageService.translateRecipe(englishRecipe, 'Gujarati');
      expect(AppLanguageService.hasGujarati(gujaratiRecipe.name), isTrue);
      expect(AppLanguageService.hasGujarati(gujaratiRecipe.description), isTrue);
      expect(gujaratiRecipe.steps.isNotEmpty, isTrue);
      expect(AppLanguageService.hasGujarati(gujaratiRecipe.steps.first.instruction), isTrue);
      expect(gujaratiRecipe.availableIngredients.first.name.contains('ટામેટાં'), isTrue);

      final hindiRecipe = AppLanguageService.translateRecipe(englishRecipe, 'Hindi');
      expect(AppLanguageService.hasHindi(hindiRecipe.name), isTrue);
      expect(AppLanguageService.hasHindi(hindiRecipe.description), isTrue);
      expect(hindiRecipe.steps.isNotEmpty, isTrue);
      expect(AppLanguageService.hasHindi(hindiRecipe.steps.first.instruction), isTrue);
      expect(hindiRecipe.availableIngredients.first.name.contains('टमाटर'), isTrue);
    });
  });
}
