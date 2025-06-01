import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CertificateService extends ApiService {
  Future<List<Map<String, dynamic>>> getUserCertificates() async {
    final response = await get(
      'api/user/certificates',
      withAuth: true,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load certificates');
    }

    debugPrint(
      'COMPLETE COURSE ${response.statusCode}: ${response.body}',
    );

    final jsonBody = jsonDecode(response.body);

    final rawList = jsonBody['data']['data'] as List<dynamic>;
    return rawList.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
