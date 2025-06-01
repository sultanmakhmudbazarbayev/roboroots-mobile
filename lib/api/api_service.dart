import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart';

abstract class ApiService {
  static final String? baseUrl = dotenv.env['BASE_URL'];

  Uri buildUrl(String endpoint) {
    return Uri.parse('$baseUrl/$endpoint');
  }

  Future<Map<String, String>> buildHeaders({bool withAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('User not authenticated.');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint, {bool withAuth = true}) async {
    final url = buildUrl(endpoint);
    final headers = await buildHeaders(withAuth: withAuth);
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(String endpoint, dynamic body,
      {bool withAuth = true}) async {
    final url = buildUrl(endpoint);
    final headers = await buildHeaders(withAuth: withAuth);
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> put(String endpoint, dynamic body,
      {bool withAuth = true}) async {
    final url = buildUrl(endpoint);
    final headers = await buildHeaders(withAuth: withAuth);
    return await http.put(url, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> delete(String endpoint, {bool withAuth = true}) async {
    final url = buildUrl(endpoint);
    final headers = await buildHeaders(withAuth: withAuth);
    return await http.delete(url, headers: headers);
  }
}
