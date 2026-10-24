import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_chef_app/core/services/app_language_service.dart';
import 'package:shelf_chef_app/core/services/recipe_store.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';
import 'package:shelf_chef_app/features/recipes/screens/cooking_guide_screen.dart';
import 'package:shelf_chef_app/features/recipes/widgets/ai_generated_card.dart';
import 'package:shelf_chef_app/features/recipes/widgets/cooking_steps_list.dart';
import 'package:shelf_chef_app/features/recipes/widgets/recipes_tab_header.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Suggested Recipe Cooking Steps Tests', () {
    test('Suggested recipe from GET /recipes without steps gets cooking steps auto-generated', () {
      final json = {
        "name": "Aloo Tomato Nu Shaak with Rotli",
        "category": "Gujarati",
        "cuisine": "Gujarati",
        "cook_time": "30 mins",
        "servings": 2,
        "match": 85,
        "difficulty": "Easy",
        "reason": "A classic everyday Gujarati meal using potatoes and tomatoes.",
        "ingredients": [
          {"name": "Potatoes", "required_quantity": 400, "unit": "g", "status": "Available"},
          {"name": "Tomatoes", "required_quantity": 300, "unit": "g", "status": "Available"},
          {"name": "Whole Wheat Flour", "required_quantity": 200, "unit": "g", "status": "Available"},
          {"name": "Cooking Oil", "required_quantity": 2, "unit": "tbsp", "status": "Staple"},
          {"name": "Salt", "required_quantity": 1, "unit": "tsp", "status": "Staple"}
        ],
        "id": 1
      };

      final recipe = GeneratedRecipe.fromJson(json);

      expect(recipe.steps, isNotEmpty);
      expect(recipe.instructions, isNotEmpty);
      expect(recipe.steps.length, greaterThanOrEqualTo(4));
      expect(recipe.instructions.any((s) => s.toLowerCase().contains('rotli') || s.toLowerCase().contains('potato')), isTrue);
    });

    test('All 3 suggested recipes from real backend response get relevant cooking steps', () {
      final backendResponse = [
        {
          "name": "Aloo Tomato Nu Shaak with Rotli",
          "category": "Gujarati",
          "cook_time": "30 mins",
          "servings": 2,
          "ingredients": [
            {"name": "Potatoes", "status": "Available"},
            {"name": "Tomatoes", "status": "Available"},
            {"name": "Whole Wheat Flour", "status": "Available"}
          ]
        },
        {
          "name": "Aloo Jeera with Plain Rice",
          "category": "Indian",
          "cook_time": "25 mins",
          "servings": 2,
          "ingredients": [
            {"name": "Potatoes", "status": "Available"},
            {"name": "Rice", "status": "Available"}
          ]
        },
        {
          "name": "Pan-Fried Potato Wedges with Tomato Dip",
          "category": "Global",
          "cook_time": "20 mins",
          "servings": 2,
          "ingredients": [
            {"name": "Potatoes", "status": "Available"},
            {"name": "Tomatoes", "status": "Available"}
          ]
        }
      ];

      for (final raw in backendResponse) {
        final recipe = GeneratedRecipe.fromJson(raw);
        expect(recipe.steps, isNotEmpty, reason: 'Failed for ${recipe.name}');
        expect(recipe.instructions.length, greaterThanOrEqualTo(4), reason: 'Failed for ${recipe.name}');
      }
    });

    test('Saved recipe with server instructions preserves its exact instructions', () {
      final json = {
        "id": 2,
        "name": "My Custom Dal",
        "category": "Indian",
        "instructions": [
          "Special custom step 1: boil with turmeric.",
          "Special custom step 2: pour secret garlic tadka."
        ],
        "ingredients": [
          {"name": "Lentils", "status": "Available"}
        ]
      };

      final recipe = GeneratedRecipe.fromJson(json);

      expect(recipe.steps.length, 2);
      expect(recipe.steps[0].instruction, "Special custom step 1: boil with turmeric.");
      expect(recipe.steps[1].instruction, "Special custom step 2: pour secret garlic tadka.");
    });

    test('Recipe translation into Gujarati and Hindi provides localized cooking steps', () {
      final enRecipe = GeneratedRecipe(
        name: "Aloo Tomato Nu Shaak with Rotli",
        category: "Gujarati",
        description: "Everyday meal.",
        availableIngredients: const [
          RecipeIngredientDetail(name: "Potatoes", quantity: "400 g"),
          RecipeIngredientDetail(name: "Tomatoes", quantity: "300 g"),
        ],
      );

      final guRecipe = AppLanguageService.translateRecipe(enRecipe, 'Gujarati');
      expect(guRecipe.steps, isNotEmpty);
      expect(guRecipe.instructions.any((s) => AppLanguageService.hasGujarati(s)), isTrue);

      final hiRecipe = AppLanguageService.translateRecipe(enRecipe, 'Hindi');
      expect(hiRecipe.steps, isNotEmpty);
      expect(hiRecipe.instructions.any((s) => AppLanguageService.hasHindi(s)), isTrue);
    });

    testWidgets('CookingGuideScreen displays cooking steps when opened for a suggested recipe', (tester) async {
      final suggestedRecipe = GeneratedRecipe.fromJson({
        "name": "Aloo Tomato Nu Shaak with Rotli",
        "category": "Gujarati",
        "cook_time": "30 mins",
        "servings": 2,
        "ingredients": [
          {"name": "Potatoes", "status": "Available"},
          {"name": "Tomatoes", "status": "Available"}
        ]
      });

      await tester.pumpWidget(
        MaterialApp(
          home: CookingGuideScreen(
            recipe: suggestedRecipe,
            peopleCount: 2,
            language: 'English',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CookingStepsList), findsOneWidget);
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('dice the potatoes'), findsOneWidget);
    });

    test('RecipeStore stores and loads saved recipes purely locally', () async {
      final store = RecipeStore.instance;
      const recipe = GeneratedRecipe(
        name: 'Local Test Shaak',
        category: 'Gujarati',
        description: 'Test shaak description',
      );

      // Save locally
      final saved = await store.toggleSaveRecipe(recipe);
      expect(store.isRecipeSaved(recipe), isTrue);
      expect(store.saved.any((r) => r.name == 'Local Test Shaak'), isTrue);

      // Reload from local storage
      await store.loadSaved();
      expect(store.isRecipeSaved(recipe), isTrue);
      expect(store.saved.any((r) => r.name == 'Local Test Shaak'), isTrue);

      // Unsave locally
      await store.toggleSaveRecipe(saved);
      expect(store.isRecipeSaved(recipe), isFalse);
      expect(store.saved.any((r) => r.name == 'Local Test Shaak'), isFalse);
    });

    testWidgets('Improvised RecipesTabHeader renders title, subtitle, AI Smart badge and actions', (tester) async {
      var refreshed = false;
      var generated = false;

      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipesTabHeader(
              onRefresh: () => refreshed = true,
              onGenerate: () => generated = true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('AI Smart'), findsOneWidget);
      expect(find.text('Zero-waste meals from your pantry'), findsOneWidget);
      expect(find.text('AI Chef'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.refresh_rounded));
      expect(refreshed, isTrue);

      await tester.tap(find.text('AI Chef'));
      expect(generated, isTrue);
    });

    testWidgets('Improvised RecipesSegmentToggle renders capsule toggle and updates on selection', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => RecipesSegmentToggle(
                selected: selectedIndex,
                savedCount: 3,
                onChanged: (val) => setState(() => selectedIndex = val),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Suggested'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);
    });

    testWidgets('RecipesTabHeader renders without overflow on 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipesTabHeader(
              onRefresh: () {},
              onGenerate: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Recipes'), findsOneWidget);
      expect(find.text('AI Smart'), findsOneWidget);
    });

    testWidgets('AiGeneratedCard renders without overflow on 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final recipe = GeneratedRecipe.fromJson({
        "name": "Gujarati Rasawala Bateta Shaak with Rotli",
        "category": "Gujarati",
        "cook_time": "35-40 mins",
        "servings": 4,
        "match_percentage": "95%",
        "ingredients": [
          {"name": "Potatoes", "status": "Available"},
          {"name": "Tomatoes", "status": "Available"}
        ]
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AiGeneratedCard(
                recipe: recipe,
                peopleCount: 4,
                isDark: false,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Gujarati Rasawala Bateta Shaak with Rotli'), findsOneWidget);
      expect(find.text(recipe.prepTime), findsOneWidget);
    });
  });
}
