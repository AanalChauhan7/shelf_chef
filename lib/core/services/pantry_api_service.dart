import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/pantry/models/pantry_item.dart';

/// HTTP Service for Smart Pantry API Integration.
/// Supports both Mobile (native TCP) and Web (CORS proxy fallback).
class PantryApiService {
  static const String baseUrl = 'https://smart-pantry-6t0v.onrender.com/pantry';
  static const String bulkUrl = '$baseUrl/bulk';

  static Uri _buildUri(String rawUrl) {
    if (kIsWeb) {
      // Use CORS proxy on Flutter Web to bypass browser cross-origin restriction
      return Uri.parse('https://corsproxy.io/?${Uri.encodeComponent(rawUrl)}');
    }
    return Uri.parse(rawUrl);
  }

  /// Fetch all pantry items from GET /pantry
  static Future<List<PantryItem>> fetchPantryItems() async {
    try {
      final response = await http
          .get(
            _buildUri(baseUrl),
            headers: {'accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((item) => PantryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (kIsWeb) {
        final directRes = await http.get(
          Uri.parse(baseUrl),
          headers: {'accept': 'application/json'},
        );
        if (directRes.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(directRes.body);
          return jsonList
              .map((i) => PantryItem.fromJson(i as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      if (kIsWeb) {
        try {
          final directRes = await http.get(
            Uri.parse(baseUrl),
            headers: {'accept': 'application/json'},
          );
          if (directRes.statusCode == 200) {
            final List<dynamic> jsonList = jsonDecode(directRes.body);
            return jsonList
                .map((i) => PantryItem.fromJson(i as Map<String, dynamic>))
                .toList();
          }
        } catch (_) {}
      }
      if (kDebugMode) print('Pantry GET exception: $e');
      return [];
    }
  }

  /// Bulk post items to POST /pantry/bulk
  static Future<bool> bulkPostPantryItems(List<PantryItem> items) async {
    if (items.isEmpty) return true;
    final bodyPayload = jsonEncode({
      'items': items.map((item) => item.toBulkPostJson()).toList(),
    });

    try {
      final response = await http
          .post(
            _buildUri(bulkUrl),
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
            },
            body: bodyPayload,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (kIsWeb) {
        final directRes = await http.post(
          Uri.parse(bulkUrl),
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: bodyPayload,
        );
        return directRes.statusCode == 200 || directRes.statusCode == 201;
      }
      return false;
    } catch (e) {
      if (kIsWeb) {
        try {
          final directRes = await http.post(
            Uri.parse(bulkUrl),
            headers: {'accept': '*/*', 'Content-Type': 'application/json'},
            body: bodyPayload,
          );
          return directRes.statusCode == 200 || directRes.statusCode == 201;
        } catch (_) {}
      }
      if (kDebugMode) print('Bulk POST exception: $e');
      return false;
    }
  }

  /// Convenience helper to post a single item
  static Future<bool> addSinglePantryItem(PantryItem item) async {
    return bulkPostPantryItems([item]);
  }

  /// Upload and parse grocery receipt via POST /scan-receipt
  static Future<List<PantryItem>?> scanReceiptImage(
    Uint8List imageBytes,
    String filename,
  ) async {
    final rawUrl = 'https://smart-pantry-6t0v.onrender.com/scan-receipt';
    final uri = _buildUri(rawUrl);

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers['accept'] = 'application/json';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: filename.isNotEmpty ? filename : 'receipt.jpg',
        ),
      );

      final streamedRes =
          await request.send().timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamedRes);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];
        final items = productsJson
            .map((p) => PantryItem.fromJson(p as Map<String, dynamic>))
            .toList();

        if (items.isNotEmpty) {
          await bulkPostPantryItems(items);
        }
        return items;
      } else if (kIsWeb) {
        final directReq = http.MultipartRequest('POST', Uri.parse(rawUrl));
        directReq.headers['accept'] = 'application/json';
        directReq.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: filename.isNotEmpty ? filename : 'receipt.jpg',
          ),
        );
        final directStreamed =
            await directReq.send().timeout(const Duration(seconds: 45));
        final directRes = await http.Response.fromStream(directStreamed);
        if (directRes.statusCode == 200 || directRes.statusCode == 201) {
          final Map<String, dynamic> data = jsonDecode(directRes.body);
          final List<dynamic> productsJson = data['products'] ?? [];
          final items = productsJson
              .map((p) => PantryItem.fromJson(p as Map<String, dynamic>))
              .toList();
          if (items.isNotEmpty) {
            await bulkPostPantryItems(items);
          }
          return items;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Scan receipt error: $e');
      return null;
    }
  }
}
