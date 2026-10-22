import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_chef_app/core/services/shopping_api_service.dart';
import 'package:shelf_chef_app/features/cart/models/shopping_item.dart';
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
}
