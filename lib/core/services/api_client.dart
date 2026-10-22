import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Parsed HTTP response returned by [ApiClient].
class ApiResponse {
  final int statusCode;
  final dynamic data;

  const ApiResponse(this.statusCode, this.data);

  bool get ok => statusCode >= 200 && statusCode < 300;
}

/// Thin shared HTTP client for the Smart Pantry backend.
///
/// - One place for the base URL, headers and timeouts.
/// - On Flutter Web it tries the API directly first and, if the browser blocks
///   the request (CORS), retries through a CORS proxy.
/// - Returns `null` only when the server could not be reached at all.
class ApiClient {
  static const String baseUrl = 'https://smart-pantry-6t0v.onrender.com';

  /// Render free-tier servers can take ~30-60s to wake up after idling.
  static const Duration defaultTimeout = Duration(seconds: 60);

  static Future<ApiResponse?> request(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    Duration timeout = defaultTimeout,
  }) async {
    final direct = Uri.parse('$baseUrl$path').replace(
      queryParameters: (query == null || query.isEmpty) ? null : query,
    );
    final attempts = <Uri>[
      direct,
      if (kIsWeb)
        Uri.parse('https://corsproxy.io/?${Uri.encodeComponent('$direct')}'),
    ];

    for (final uri in attempts) {
      try {
        final res = await _send(method, uri, body).timeout(timeout);
        return ApiResponse(res.statusCode, _decode(res.body));
      } catch (e) {
        if (kDebugMode) print('API $method $uri failed: $e');
      }
    }
    return null;
  }

  static Future<http.Response> _send(String method, Uri uri, Object? body) {
    final headers = <String, String>{
      'accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
    };
    final encoded = body == null ? null : jsonEncode(body);

    switch (method) {
      case 'POST':
        return http.post(uri, headers: headers, body: encoded);
      case 'PATCH':
        return http.patch(uri, headers: headers, body: encoded);
      case 'DELETE':
        return http.delete(uri, headers: headers);
      default:
        return http.get(uri, headers: headers);
    }
  }

  static dynamic _decode(String raw) {
    if (raw.trim().isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return raw;
    }
  }

  /// Pulls a list out of a response body that may be a bare list or wrapped
  /// in an object such as `{ "recipes": [...] }`.
  static List<dynamic> extractList(dynamic body, List<String> keys) {
    if (body is List) return body;
    if (body is Map) {
      for (final key in keys) {
        final value = body[key];
        if (value is List) return value;
      }
    }
    return const [];
  }
}
