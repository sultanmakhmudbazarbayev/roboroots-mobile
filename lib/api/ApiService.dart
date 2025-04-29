import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

class ApiService {
  final String baseUrl = 'https://robo.responcy.net';

  Future<http.Response> getData(String endpoint) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated.');
    }
    final url = Uri.parse('$baseUrl/$endpoint');

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
