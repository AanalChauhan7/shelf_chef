import '../../features/cart/models/shopping_item.dart';
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
    return ApiClient.extractList(res.data, _listKeys)
        .where((i) => i != null)
        .map(_parseItem)
        .toList();
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

  /// Removes every item from the list.
  static Future<bool> clearShoppingList() async {
    final res = await ApiClient.request('DELETE', '$_base/clear');
    return res != null && res.ok;
  }

  /// Asks the server to build the list from the pantry. Returns null on
  /// success, otherwise a message that is safe to show to the user.
  static Future<String?> generateShoppingList() async {
    final res = await ApiClient.request('POST', '$_base/generate');
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
