import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/recipes/models/generated_recipe.dart';
import '../../features/recipes/models/ingredient_item.dart';
import 'recipe_fallback_engine.dart';

/// Service calling Gemini AI to generate recipes matching the TV show host persona.
class GeminiRecipeService {
  static const String _defaultApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyDemoFreeKeyShelfChefAI2026',
  );

  /// Generates custom recipes using Gemini AI.
  static Future<List<GeneratedRecipe>> generateRecipes({
    required List<IngredientItem> ingredients,
    required int peopleCount,
    String preferredLanguage = 'English',
    String? customApiKey,
  }) async {
    final apiKey = (customApiKey != null && customApiKey.isNotEmpty)
        ? customApiKey
        : _defaultApiKey;

    final ingredientListStr = ingredients.isEmpty
        ? 'Gram flour (besan), buttermilk, potatoes, tomatoes, onions, spices'
        : ingredients
              .map((i) => '- ${i.name}: ${i.quantity} ${i.unit}')
              .join('\n');

    final prompt =
        '''
You are ShelfChef AI's expert recipe assistant — imagine a warm, skilled TV cooking show host who explains every step clearly, with technique tips, so even a beginner cannot go wrong.

USER CONTEXT:
- Available ingredients (name, quantity, unit):
$ingredientListStr
- Number of people to cook for: $peopleCount

YOUR TASK:
Generate exactly 3 recipe suggestions using primarily the ingredients listed above, scaled appropriately for $peopleCount people:

1. GUJARATI recipe
2. OTHER INDIAN (non-Gujarati) recipe
3. GLOBAL / International recipe

RULES:
- Prioritize using the ingredients the user already has.
- You may assume the user has 2-3 basic staple/pantry ingredients even if not listed (e.g. salt, oil, water, common spices like turmeric or red chili powder). Clearly mark these as "assumed" in the ingredients list.
- Do NOT assume any other ingredient not in the user's list unless it falls into the basic staple exception above.
- If a recipe requires ingredients beyond the user's list and the staple exception, list them clearly under "missingIngredients" with quantity needed — do not silently skip them.
- Scale all ingredient quantities to match $peopleCount servings.
- Steps must be detailed, sequential, and instructional — like a professional chef narrating a cooking show: include prep actions, exact timing, flame/heat level, texture/visual cues (e.g. "cook until the onions turn golden brown, about 4-5 minutes"), and any pro tips.
- Each step should be a single clear action (don't combine multiple actions into one step).
- Keep the tone encouraging and vivid, but concise — no filler sentences.
- Use metric units for weight/volume (grams, ml) and common Indian units where natural (katori, tsp, tbsp) if appropriate.
- WRITE ALL TEXT IN THE PREFERRED LANGUAGE: "$preferredLanguage" (Gujarati: ગુજરાતી, Hindi: हिंदी, English: English).

OUTPUT FORMAT:
Respond with ONLY valid JSON, no markdown, no code fences, no extra commentary. Follow this exact schema:

{
  "recipes": [
    {
      "category": "Gujarati",
      "name": "Recipe Name in $preferredLanguage",
      "description": "Appetizing 1-2 line summary in $preferredLanguage",
      "servings": $peopleCount,
      "prepTimeMinutes": 15,
      "cookTimeMinutes": 15,
      "totalTimeMinutes": 30,
      "difficulty": "Easy",
      "caloriesPerServing": 350,
      "availableIngredients": [
        { "name": "Ingredient Name", "quantity": "amount with unit" }
      ],
      "assumedStaples": [
        { "name": "Staple Name", "quantity": "amount with unit" }
      ],
      "missingIngredients": [
        { "name": "Missing Name", "quantity": "amount with unit" }
      ],
      "steps": [
        {
          "stepNumber": 1,
          "instruction": "Detailed single action in $preferredLanguage",
          "durationMinutes": 5
        }
      ],
      "chefTip": "Pro technique tip in $preferredLanguage"
    }
  ]
}

If, and only if, none of the user's ingredients can reasonably form a dish in a category, still provide a best-effort recipe for that category using minimal available ingredients plus clearly listed missing ones — never omit a category entirely.
''';

    try {
      if (apiKey.startsWith('AIzaSyDemo')) {
        await Future.delayed(const Duration(milliseconds: 900));
        return RecipeFallbackEngine.getFallbackRecipes(
          ingredients,
          peopleCount,
          preferredLanguage,
        );
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text != null && text.isNotEmpty) {
        final cleanJson = text
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final dynamic decoded = jsonDecode(cleanJson);
        List<dynamic> list = [];
        if (decoded is Map<String, dynamic> && decoded.containsKey('recipes')) {
          list = decoded['recipes'] as List<dynamic>;
        } else if (decoded is List) {
          list = decoded;
        }

        if (list.isNotEmpty) {
          return list
              .map((j) => GeneratedRecipe.fromJson(j as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Gemini API notice: $e. Using fallback engine.');
      }
    }

    return RecipeFallbackEngine.getFallbackRecipes(
      ingredients,
      peopleCount,
      preferredLanguage,
    );
  }
}
