import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/cart/models/shopping_item.dart';

/// HTTP Service for Smart Shopping List API Integration.
/// Supports Mobile & Web (CORS proxy fallback).
class ShoppingApiService {
  static const String baseUrl =
      'https://smart-pantry-6t0v.onrender.com/shopping-list';
  static const String addUrl = '$baseUrl/add';

  static Uri _buildUri(String rawUrl) {
    if (kIsWeb) {
      return Uri.parse('https://corsproxy.io/?${Uri.encodeComponent(rawUrl)}');
    }
    return Uri.parse(rawUrl);
  }

  /// Fetch all shopping list items from GET /shopping-list
  static Future<List<ShoppingItem>> fetchShoppingList() async {
    try {
      final response = await http
          .get(
            _buildUri(baseUrl),
            headers: {'accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

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
      } else if (kIsWeb) {
        final directRes = await http
            .get(
              Uri.parse(baseUrl),
              headers: {'accept': 'application/json'},
            )
            .timeout(const Duration(seconds: 10));
        if (directRes.statusCode == 200) {
          final dynamic body = jsonDecode(directRes.body);
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
      }
      return [];
    } catch (e) {
      if (kIsWeb) {
        try {
          final directRes = await http
              .get(
                Uri.parse(baseUrl),
                headers: {'accept': 'application/json'},
              )
              .timeout(const Duration(seconds: 10));
          if (directRes.statusCode == 200) {
            final dynamic body = jsonDecode(directRes.body);
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
        } catch (_) {}
      }
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
      'item_type': itemType,
    });

    try {
      final response = await http
          .post(
            _buildUri(addUrl),
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
            },
            body: payload,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (kIsWeb) {
        final directRes = await http.post(
          Uri.parse(addUrl),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: payload,
        );
        return directRes.statusCode == 200 || directRes.statusCode == 201;
      }
      return false;
    } catch (e) {
      if (kIsWeb) {
        try {
          final directRes = await http.post(
            Uri.parse(addUrl),
            headers: {'accept': '*/*', 'Content-Type': 'application/json'},
            body: payload,
          );
          return directRes.statusCode == 200 || directRes.statusCode == 201;
        } catch (_) {}
      }
      if (kDebugMode) print('Shopping POST exception: $e');
      return false;
    }
  }
}
