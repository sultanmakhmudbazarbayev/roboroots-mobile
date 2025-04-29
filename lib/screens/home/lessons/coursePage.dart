import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:roboroots/screens/home/lessons/courseLessonsPage.dart';
import 'package:roboroots/widgets/banner_ad_widget.dart'; // Ensure correct import path

/// CoursesPage: Displays a list of courses with progress.
class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  // Dummy course data including progress.
  final List<Map<String, dynamic>> courses = const [
    {
      'title': 'Flutter for Beginners',
      'description': 'Learn the basics of Flutter.',
      'progress': 0.7, // 70% complete
    },
    {
      'title': 'Advanced Flutter',
      'description': 'Dive deeper into Flutter.',
      'progress': 0.3, // 30% complete
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Courses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Column(
        children: [
          // Expanded ListView for courses.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to lessons page for this course.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseLessonsPage(
                          courseTitle: course['title']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B6FFF),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    course['description']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.school,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Course progress indicator.
                        LinearProgressIndicator(
                          value: course['progress'],
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                          minHeight: 6,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${(course['progress'] * 100).toInt()}% completed",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Insert the BannerAdWidget inside the body (not as bottomNavigationBar).
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.red.withOpacity(0.3), // Visual cue for ad area
              child: BannerAdWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
