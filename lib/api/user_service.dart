import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class UserService extends ApiService {
  Future<Map<String, dynamic>> getUserInfo() async {
    final response = await get('api/user', withAuth: true);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['status'] == 'OK' && body['data']['userData'] != null) {
        return body['data'];
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to fetch user info: ${response.body}');
    }
  }

  Future<int> checkStrike() async {
    final response = await get('api/user/check-strike', withAuth: true);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      // Adjusted to use 'message' and 'strikeDaysCount'
      if (body['message'] == 'OK' &&
          body['data'] != null &&
          body['data']['strikeDaysCount'] != null) {
        return body['data']['strikeDaysCount'];
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to check strike: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    final response = await get('api/user/notifications', withAuth: true);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['message'] == 'OK' &&
          body['data'] != null &&
          body['data']['data'] != null) {
        final List notifications = body['data']['data'];
        return notifications.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to fetch notifications: ${response.body}');
    }
  }
}
