import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_chef_app/core/services/recipe_store.dart';
import 'package:shelf_chef_app/features/dashboard/widgets/ai_recipe_card.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  final sampleRecipe = GeneratedRecipe.fromJson({
    "id": 1,
    "name": "Aloo Tomato Nu Shaak",
    "category": "Gujarati",
    "cuisine": "Gujarati",
    "cook_time": "25 mins",
    "servings": 2,
    "match": 92,
    "difficulty": "Easy",
    "reason": "Uses 4 ingredients already in your pantry shelf.",
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
        "name": "Coriander",
        "required_quantity": 50,
        "unit": "g",
        "status": "Available"
      },
    ],
    "nutrition": {"calories": "240 kcal"},
  });

  final longRecipe = GeneratedRecipe.fromJson({
    "id": 2,
    "name": "Super Long Traditional Kathiyawadi Spiced Sev Tameta Nu Shaak Deluxe Special",
    "category": "Authentic Gujarati Regional Cuisine",
    "cuisine": "Gujarati",
    "cook_time": "1 hr 45 mins",
    "servings": 12,
    "match": 100,
    "difficulty": "Intermediate-Master",
    "reason": "This is an extremely long detailed recommendation explanation to test that multiple lines wrap cleanly without any horizontal or vertical overflow errors occurring on any viewport size.",
    "ingredients": [
      {
        "name": "Finely Chopped Vine-Ripened Farm Fresh Red Tomatoes",
        "required_quantity": 800,
        "unit": "g",
        "status": "Available"
      },
      {
        "name": "Crunchy Ratlami Spicy Gram Flour Noodles",
        "required_quantity": 500,
        "unit": "g",
        "status": "Available"
      },
    ],
    "nutrition": {"calories": "1,450 kcal"},
  });

  group('AiRecipeCard Imageless Design Tests', () {
    testWidgets('renders imageless card with metrics, ingredients, and no image widgets', (tester) async {
      SharedPreferences.setMockInitialValues({
        'recipe_suggestions_cache_v2': jsonEncode([sampleRecipe.toJson()]),
      });
      await RecipeStore.instance.ensureSuggested(servings: 2, language: 'English');

      bool cooked = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiRecipeCard(
                onStartCooking: () => cooked = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure no image widgets are rendered
      expect(find.byType(Image), findsNothing);

      // Verify header contents
      expect(find.textContaining('92% MATCH'), findsOneWidget);
      expect(find.textContaining('Gujarati • 2 Servings'), findsOneWidget);

      // Verify title & reason
      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
      expect(find.text('Uses 4 ingredients already in your pantry shelf.'), findsOneWidget);

      // Verify metrics
      expect(find.text('25 mins'), findsOneWidget);
      expect(find.text('240 kcal'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);

      // Verify pantry ingredient chips
      expect(find.text('Potatoes'), findsOneWidget);
      expect(find.text('Tomatoes'), findsOneWidget);

      // Tap start cooking
      await tester.tap(find.text('Start Cooking Mode'));
      expect(cooked, isTrue);
    });

    testWidgets('renders without overflow on narrow 320x568 screen in Dark Mode', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({
        'recipe_suggestions_cache_v2': jsonEncode([sampleRecipe.toJson()]),
      });
      await RecipeStore.instance.ensureSuggested(servings: 2, language: 'English');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiRecipeCard(
                onStartCooking: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('renders without overflow on ultra-narrow 280x653 screen (Galaxy Fold outer display)', (tester) async {
      tester.view.physicalSize = const Size(280, 653);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({
        'recipe_suggestions_cache_v2': jsonEncode([sampleRecipe.toJson()]),
      });
      await RecipeStore.instance.ensureSuggested(servings: 2, language: 'English');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AiRecipeCard(
                onStartCooking: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
    });

    testWidgets('renders without overflow with extremely long text content', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({
        'recipe_suggestions_cache_v2': jsonEncode([longRecipe.toJson()]),
      });
      await RecipeStore.instance.ensureSuggested(servings: 12, language: 'English');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiRecipeCard(
                recipe: longRecipe,
                onStartCooking: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('100% MATCH'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('renders without overflow under high accessibility font scale (2.0x)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2.0),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: AiRecipeCard(
                  recipe: sampleRecipe,
                  onStartCooking: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
    });

    testWidgets('renders without overflow when recipe is null (empty or loading state)', (tester) async {
      tester.view.physicalSize = const Size(280, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AiRecipeCard(
                recipe: null,
                onStartCooking: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
      expect(find.text('Start Cooking Mode'), findsOneWidget);
    });
  });
}
