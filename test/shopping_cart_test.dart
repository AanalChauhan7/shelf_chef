import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_chef_app/core/services/shopping_api_service.dart';
import 'package:shelf_chef_app/features/cart/models/shopping_item.dart';
import 'package:shelf_chef_app/features/cart/widgets/cart_progress_bar.dart';
import 'package:shelf_chef_app/features/cart/widgets/cart_segment_toggle.dart';
import 'package:shelf_chef_app/features/cart/widgets/shopping_item_tile.dart';
import 'package:shelf_chef_app/features/cart/widgets/shopping_list_header.dart';
import 'package:shelf_chef_app/features/recipes/models/generated_recipe.dart';

void main() {
  group('ShoppingItem model tests', () {
    test('parses real backend GET /shopping-list item correctly', () {
      final json = {
        "id": 1,
        "product_id": null,
        "name": "Stapler",
        "display_name": "Stapler",
        "quantity": 1.0,
        "unit": "",
        "checked": false,
        "source": "manual"
      };

      final item = ShoppingItem.fromJson(json);
      expect(item.id, "1");
      expect(item.name, "Stapler");
      expect(item.quantity, "1");
      expect(item.unit, "");
      expect(item.isChecked, isFalse);
      expect(item.itemType, "manual");
    });

    test('parses recipe-generated shopping item correctly', () {
      final json = {
        "id": 2,
        "product_id": 1194,
        "name": "Mustard Seeds",
        "display_name": "Mustard Seeds",
        "quantity": 1.0,
        "unit": "tsp",
        "checked": true,
        "source": "recipe"
      };

      final item = ShoppingItem.fromJson(json);
      expect(item.id, "2");
      expect(item.name, "Mustard Seeds");
      expect(item.displayQtyUnit, "1 tsp");
      expect(item.isChecked, isTrue);
      expect(item.itemType, "recipe");
    });
  });

  group('Recipe missing ingredients conversion', () {
    test('recipe missing ingredients are prepared correctly for shopping list', () {
      const recipe = GeneratedRecipe(
        category: 'Gujarati',
        name: 'Sev Tamatar Nu Shaak',
        description: 'Tangy tomato curry with sev',
        missingIngredients: [
          RecipeIngredientDetail(
            name: 'Ratlami Sev',
            quantity: '1 cup',
            type: 'missing',
          ),
          RecipeIngredientDetail(
            name: 'Turmeric Powder',
            quantity: '0.5 tsp',
            type: 'missing',
          ),
        ],
      );

      expect(recipe.missingIngredients.length, 2);
      expect(recipe.missingIngredients.first.name, 'Ratlami Sev');
      expect(recipe.missingIngredients.first.quantity, '1 cup');
    });
  });

  group('parseQuantity', () {
    test('handles common recipe quantities', () {
      var q = ShoppingApiService.parseQuantity('1 cup');
      expect((q.qty, q.unit), (1, 'cup'));
      q = ShoppingApiService.parseQuantity('1/2 tsp');
      expect((q.qty, q.unit), (0.5, 'tsp'));
      q = ShoppingApiService.parseQuantity('1 1/2 kg');
      expect((q.qty, q.unit), (1.5, 'kg'));
      q = ShoppingApiService.parseQuantity('250g');
      expect((q.qty, q.unit), (250, 'g'));
      q = ShoppingApiService.parseQuantity('a pinch');
      expect((q.qty, q.unit), (1, 'a pinch'));
      q = ShoppingApiService.parseQuantity('');
      expect((q.qty, q.unit), (1, ''));
    });
  });

  group('Cart UI Modernized Components Tests', () {
    testWidgets('ShoppingListHeader renders without overflow on narrow 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var addTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingListHeader(
              itemCount: 4,
              onAdd: () => addTapped = true,
              onGenerate: () {},
              onClear: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('4 items'), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      expect(addTapped, isTrue);
    });

    testWidgets('CartSegmentToggle switches between All, To Buy, and Done', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var current = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => CartSegmentToggle(
                selected: current,
                totalCount: 5,
                toBuyCount: 3,
                doneCount: 2,
                onChanged: (val) => setState(() => current = val),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('To Buy'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.text('To Buy'));
      await tester.pumpAndSettle();
      expect(current, 1);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(current, 2);
    });

    testWidgets('CartProgressCard renders counts and percentage properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CartProgressCard(
              doneCount: 3,
              totalCount: 6,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('3 of 6 items purchased'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('ShoppingItemTile renders item with status and toggles', (tester) async {
      final item = ShoppingItem(
        id: '101',
        name: 'Fresh Tomatoes',
        quantity: '500',
        unit: 'g',
        itemType: 'recipe',
        isChecked: false,
      );

      var toggled = false;
      var deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: item,
              onToggleChecked: (_) => toggled = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Fresh Tomatoes'), findsOneWidget);
      expect(find.text('500 g'), findsOneWidget);
      expect(find.text('Recipe'), findsOneWidget);

      await tester.tap(find.text('Fresh Tomatoes'));
      expect(toggled, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(deleted, isTrue);
    });
  });
}
