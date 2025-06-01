import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CourseService extends ApiService {
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    final response = await get('api/course');

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> rawList = json['data']['data'];
      return rawList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<Map<String, dynamic>> getCourseById(int id) async {
    final response = await get('api/course/$id');

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final course = json['data']['data']; // ✅ FIX: get `data` field only

      final lessons = course['Lessons'] as List? ?? [];

      // Fix video URLs too if they are relative
      for (final lesson in lessons) {
        final video = lesson['video_url'] ?? '';
        lesson['video_url'] =
            video.startsWith('/') ? '${ApiService.baseUrl}$video' : video;
      }

      return Map<String, dynamic>.from(course);
    } else {
      throw Exception('Failed to load course: ${response.statusCode}');
    }
  }

  Future<void> enrollInCourse(int courseId) async {
    final response =
        await post('api/course/$courseId/enroll', {}, withAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to enroll');
    }
  }

  Future<List<Map<String, dynamic>>> getEnrolledCourses() async {
    final response = await get('api/course/enrolled', withAuth: true);

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    final json = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(json['data']['data']);
  }

  Future<Map<String, dynamic>> getEnrolledCourseById(int id) async {
    final response = await get('api/course/enrolled/$id', withAuth: true);

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load enrolled course');
    }

    final json = jsonDecode(response.body);
    // This matches your controller: { message, data: { data: course } }
    final course = json['data']['data'] as Map<String, dynamic>;

    // Fix relative URLs
    final img = course['image'] as String?;
    if (img != null && img.startsWith('/')) {
      course['image'] = '${ApiService.baseUrl}$img';
    }
    final lessons = course['Lessons'] as List? ?? [];
    for (final l in lessons) {
      final video = l['video_url'] as String? ?? '';
      if (video.startsWith('/')) {
        l['video_url'] = '${ApiService.baseUrl}$video';
      }
    }

    return course;
  }

  Future<void> saveLessonProgress(int lessonId, double progress) async {
    final body = {'progress': progress};
    final response = await post(
      'api/lesson/$lessonId/progress',
      body,
      withAuth: true,
    );

    debugPrint('SAVE PROGRESS ${response.statusCode}: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to save lesson progress');
    }
  }

  Future<void> submitQuizResult(int lessonId, int score) async {
    final endpoint = 'api/lesson/$lessonId/result';
    final body = {'score': score};
    final response = await post(endpoint, body, withAuth: true);
    if (response.statusCode != 200) {
      throw Exception('Failed to submit quiz result');
    }
  }

  Future<void> completeCourse(int courseId) async {
    // Adjust the path if your server uses a different route
    final response = await post(
      'api/course/$courseId/complete',
      {}, // no extra body
      withAuth: true, // ensure we send the JWT
    );

    debugPrint(
      'COMPLETE COURSE ${response.statusCode}: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete course');
    }
  }
}
