import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    // Decode and store user info
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    await prefs.setString('user_base_info', jsonEncode(decodedToken));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_base_info');
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final response = await post(
      'api/auth/login',
      {'email': email, 'password': password},
      withAuth: false,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['data']?['access_token'];
      if (token != null) {
        await saveToken(token);
        return true;
      }
    }

    throw Exception('Login failed: ${response.body}');
  }

  Future<bool> register({
    required String email,
    required String fullName,
    required String password,
    required String role,
  }) async {
    final response = await post(
      'api/auth/register',
      {
        'email': email,
        'full_name': fullName,
        'password': password,
        'role': role,
      },
      withAuth: false,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final token = body['data']?['access_token'];
      if (token != null) {
        await saveToken(token);
        return true;
      }
    }

    throw Exception('Registration failed: ${response.body}');
  }
}
