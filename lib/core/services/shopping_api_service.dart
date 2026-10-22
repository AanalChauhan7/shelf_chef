import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/cart/models/shopping_item.dart';

/// HTTP Service for Smart Shopping List API Integration.
class ShoppingApiService {
  static const String baseUrl =
      'https://smart-pantry-6t0v.onrender.com/shopping-list';
  static const String addUrl = '$baseUrl/add';

  static const Map<String, String> _headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  /// Fetch all shopping list items from GET /shopping-list
  static Future<List<ShoppingItem>> fetchShoppingList() async {
    try {
      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> jsonList = [];
        if (body is List) {
          jsonList = body;
        } else if (body is Map<String, dynamic>) {
          jsonList = body['value'] ??
              body['items'] ??
              body['shopping_list'] ??
              body['products'] ??
              body['data'] ??
              [];
        }
        return jsonList
            .where((i) => i != null)
            .map((i) {
              if (i is Map<String, dynamic>) {
                return ShoppingItem.fromJson(i);
              } else if (i is Map) {
                return ShoppingItem.fromJson(Map<String, dynamic>.from(i));
              } else {
                return ShoppingItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: i.toString(),
                  quantity: '1',
                );
              }
            })
            .toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Shopping GET exception: $e');
      return [];
    }
  }

  /// Add item to shopping list via POST /shopping-list/add
  static Future<bool> addShoppingItem({
    required String name,
    required String quantity,
    required String unit,
    required String itemType,
  }) async {
    final payload = jsonEncode({
      'name': name,
      'quantity': num.tryParse(quantity) ?? 1,
      'unit': unit,
    });

    try {
      final response = await http
          .post(
            Uri.parse(addUrl),
            headers: _headers,
            body: payload,
          )
          .timeout(const Duration(seconds: 15));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) print('Shopping POST exception: $e');
      return false;
    }
  }

  /// Toggle check state of an item via PATCH /shopping-list/check/{item_id}
  static Future<bool> toggleCheckItem(String itemId) async {
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/check/$itemId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print('Shopping PATCH exception: $e');
      return false;
    }
  }

  /// Remove item from shopping list via DELETE /shopping-list/items/{item_id}
  static Future<bool> deleteShoppingItem(String itemId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/items/$itemId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print('Shopping DELETE exception: $e');
      return false;
    }
  }
}
