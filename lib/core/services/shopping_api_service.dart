import '../../features/cart/models/shopping_item.dart';
import '../../features/recipes/models/generated_recipe.dart';
import 'api_client.dart';

/// Thrown when the shopping list can't be loaded; [message] is user-safe.
class ShoppingApiException implements Exception {
  final String message;
  const ShoppingApiException(this.message);

  @override
  String toString() => message;
}

/// Smart Pantry shopping-list endpoints (via the shared [ApiClient], so they
/// get the same base URL, 60s Render wake-up timeout and web CORS fallback):
///
/// - `GET    /shopping-list`                  the whole list
/// - `POST   /shopping-list/add`              add an item
/// - `PATCH  /shopping-list/check/{item_id}`  toggle checked
/// - `DELETE /shopping-list/items/{item_id}`  remove an item
/// - `DELETE /shopping-list/clear`            empty the list
/// - `POST   /shopping-list/generate`         build the list from the pantry
class ShoppingApiService {
  static const String _base = '/shopping-list';

  static const List<String> _listKeys = [
    'value',
    'items',
    'shopping_list',
    'products',
    'data',
  ];

  /// All shopping list items. Throws [ShoppingApiException] when the server
  /// can't be reached or answers with an error (so "empty" and "failed" differ).
  static Future<List<ShoppingItem>> fetchShoppingList() async {
    final res = await ApiClient.request('GET', _base);
    if (res == null) {
      throw const ShoppingApiException(
        "Couldn't load your shopping list. Check your connection — the "
        'server may be waking up, so try again in a moment.',
      );
    }
    if (!res.ok) {
      throw ShoppingApiException(
        "Couldn't load your shopping list (server error ${res.statusCode}).",
      );
    }
    final items = <ShoppingItem>[];
    for (final raw in ApiClient.extractList(res.data, _listKeys)) {
      if (raw == null) continue;
      try {
        items.add(_parseItem(raw));
      } catch (_) {/* skip a malformed row instead of failing the list */}
    }
    return items;
  }

  static ShoppingItem _parseItem(dynamic raw) {
    if (raw is Map) {
      return ShoppingItem.fromJson(Map<String, dynamic>.from(raw));
    }
    return ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: raw.toString(),
      quantity: '1',
    );
  }

  /// Adds an item. Returns true on success.
  static Future<bool> addShoppingItem({
    required String name,
    required String quantity,
    required String unit,
    required String itemType,
  }) async {
    final res = await ApiClient.request(
      'POST',
      '$_base/add',
      body: {
        'name': name,
        'quantity': num.tryParse(quantity) ?? 1,
        'unit': unit,
        if (itemType.toLowerCase() == 'recipe') 'source': 'recipe',
      },
    );
    return res != null && res.ok;
  }

  /// Toggles the checked state of an item.
  static Future<bool> toggleCheckItem(String itemId) async {
    final res = await ApiClient.request(
      'PATCH',
      '$_base/check/${Uri.encodeComponent(itemId)}',
    );
    return res != null && res.ok;
  }

  /// Removes one item.
  static Future<bool> deleteShoppingItem(String itemId) async {
    final res = await ApiClient.request(
      'DELETE',
      '$_base/items/${Uri.encodeComponent(itemId)}',
    );
    return res != null && res.ok;
  }

  /// Removes every item from the list using `DELETE /shopping-list/clear`.
  static Future<bool> clearShoppingList() async {
    final res = await ApiClient.request('DELETE', '$_base/clear');
    return res != null && res.ok;
  }

  /// Splits a recipe quantity such as `1 cup`, `1/2 tsp`, `1 1/2 kg`, `250g`
  /// or `a pinch` into a number and a unit.
  static ({num qty, String unit}) parseQuantity(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return (qty: 1, unit: '');

    final m = RegExp(r'^(\d+\s+\d+/\d+|\d+/\d+|\d+(?:\.\d+)?|\.\d+)\s*(.*)$')
        .firstMatch(text);
    if (m == null) return (qty: 1, unit: text); // e.g. "a pinch", "to taste"

    final numPart = m.group(1)!;
    num qty = 1;
    if (numPart.contains('/')) {
      final parts = numPart.split(RegExp(r'\s+'));
      final frac = parts.last.split('/');
      final whole = parts.length == 2 ? (num.tryParse(parts.first) ?? 0) : 0;
      final d = num.tryParse(frac[1]) ?? 1;
      qty = whole + (num.tryParse(frac[0]) ?? 1) / (d == 0 ? 1 : d);
    } else {
      qty = num.tryParse(numPart) ?? 1;
    }
    if (qty <= 0) qty = 1;
    return (qty: qty, unit: (m.group(2) ?? '').trim());
  }

  /// Adds the missing ingredients of [recipe] with `POST /shopping-list/add`
  /// (one request per ingredient, skipping ones already on the list).
  /// Returns how many items were added.
  static Future<int> addMissingIngredientsFromRecipe(
    GeneratedRecipe recipe,
  ) async {
    if (recipe.missingIngredients.isEmpty) return 0;

    var existing = <String>{};
    try {
      existing = (await fetchShoppingList())
          .map((i) => i.name.trim().toLowerCase())
          .toSet();
    } catch (_) {/* can't check duplicates; just add */}

    var addedCount = 0;
    for (final ing in recipe.missingIngredients) {
      final name = ing.name.trim();
      if (name.isEmpty || existing.contains(name.toLowerCase())) continue;

      final q = parseQuantity(ing.quantity);
      final ok = await addShoppingItem(
        name: name,
        quantity: q.qty.toString(),
        unit: q.unit,
        itemType: 'recipe',
      );
      if (ok) {
        addedCount++;
        existing.add(name.toLowerCase());
      }
    }
    return addedCount;
  }

  /// Asks the server to generate shopping items for [recipeName] via `POST /shopping-list/generate`.
  static Future<String?> generateShoppingList({String? recipeName}) async {
    final effectiveName = recipeName ?? 'Aloo Tomato Nu Shaak';
    final res = await ApiClient.request(
      'POST',
      '$_base/generate',
      body: {'recipe': effectiveName},
      timeout: const Duration(seconds: 30),
    );
    if (res == null) {
      return "Couldn't reach the server. Try again in a moment.";
    }
    if (res.ok) return null;
    final detail = _detail(res.data);
    return "Couldn't generate the list (server error ${res.statusCode})"
        '${detail.isEmpty ? '.' : ': $detail'}';
  }

  /// Reads FastAPI's `{"detail": ...}` error body.
  static String _detail(dynamic data) {
    if (data is! Map) return '';
    final detail = data['detail'];
    if (detail is String) return detail;
    if (detail is List && detail.isNotEmpty && detail.first is Map) {
      return (detail.first as Map)['msg']?.toString() ?? '';
    }
    return '';
  }
}
