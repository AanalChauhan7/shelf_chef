import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';
import 'package:shelf_chef_app/features/recipes/screens/cooking_guide_screen.dart';
import 'package:shelf_chef_app/features/recipes/widgets/recipe_detail_dialog.dart';

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
    "overview": "A classic everyday Gujarati potato and tomato curry made using your main pantry staples.",
    "tips": ["Add fresh coriander right before serving for enhanced flavor."],
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
        "name": "Ratlami Sev",
        "required_quantity": 100,
        "unit": "g",
        "status": "Missing"
      },
    ],
    "nutrition": {"calories": "240 kcal"},
  });

  group('RecipeDetailDialog Imageless Design Tests', () {
    testWidgets('renders imageless dialog with metrics, in-pantry chips, missing callout and zero images', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => RecipeDetailDialog.show(
                  context,
                  recipe: sampleRecipe,
                  peopleCount: 2,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify no image widgets are rendered
      expect(find.byType(Image), findsNothing);

      // Verify header contents
      expect(find.textContaining('92% MATCH'), findsOneWidget);
      expect(find.text('Gujarati'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Verify title & description
      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
      expect(find.textContaining('A classic everyday Gujarati potato'), findsOneWidget);

      // Verify chef tip
      expect(find.textContaining('Add fresh coriander right before serving'), findsOneWidget);

      // Verify metrics
      expect(find.text('25 mins'), findsOneWidget);
      expect(find.text('240 kcal'), findsOneWidget);
      expect(find.textContaining('2 people'), findsOneWidget);

      // Verify in-pantry chips
      expect(find.textContaining('In Your Pantry (2)'), findsOneWidget);
      expect(find.textContaining('Potatoes'), findsOneWidget);
      expect(find.textContaining('Tomatoes'), findsOneWidget);

      // Verify missing ingredients callout
      expect(find.text('1 Missing Ingredient'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.textContaining('Ratlami Sev'), findsOneWidget);

      // Verify action footer
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Start Cooking'), findsOneWidget);

      // Tap start cooking and verify navigation
      await tester.tap(find.text('Start Cooking'));
      await tester.pumpAndSettle();
      expect(find.byType(CookingGuideScreen), findsOneWidget);
    });

    testWidgets('renders without overflow on narrow 320x568 screen in Dark Mode', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => RecipeDetailDialog.show(
                  context,
                  recipe: sampleRecipe,
                  peopleCount: 2,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
      expect(find.byType(Image), findsNothing);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Aloo Tomato Nu Shaak'), findsNothing);
    });

    testWidgets('renders without overflow on ultra-narrow 280x653 screen under 2.0x font scaling', (tester) async {
      tester.view.physicalSize = const Size(280, 653);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => RecipeDetailDialog.show(
                    context,
                    recipe: sampleRecipe,
                    peopleCount: 2,
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Aloo Tomato Nu Shaak'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });
}
