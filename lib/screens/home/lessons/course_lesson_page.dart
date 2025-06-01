// lib/screens/home/lessons/course_lessons_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:roboroots/api/api_service.dart';
import 'package:roboroots/api/course_service.dart';
import 'package:roboroots/widgets/video_player_widget.dart';
import 'package:roboroots/screens/home/content/quiz_screen.dart';

class CourseLessonsPage extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const CourseLessonsPage({
    Key? key,
    required this.courseId,
    required this.courseTitle,
  }) : super(key: key);

  @override
  State<CourseLessonsPage> createState() => _CourseLessonsPageState();
}

class _CourseLessonsPageState extends State<CourseLessonsPage> {
  List<Map<String, dynamic>> _lessons = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  final GlobalKey<VideoPlayerWidgetState> _videoPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadEnrolledCourse();
  }

  Future<void> _loadEnrolledCourse() async {
    try {
      final course =
          await CourseService().getEnrolledCourseById(widget.courseId);
      final lessons = List<Map<String, dynamic>>.from(course['Lessons'] ?? []);
      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
      if (_lessons.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadLesson(0);
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading course: $e")),
      );
    }
  }

  void _loadLesson(int index) {
    setState(() => _currentIndex = index);
    final raw = _lessons[index]['video_url'] as String? ?? '';
    final videoUrl = raw.startsWith('http') ? raw : '${ApiService.baseUrl}$raw';
    _videoPlayerKey.currentState?.loadVideoUrl(videoUrl);
  }

  void _skipPrevious() {
    if (_currentIndex > 0) _loadLesson(_currentIndex - 1);
  }

  void _skipNext() {
    if (_currentIndex < _lessons.length - 1) _loadLesson(_currentIndex + 1);
  }

  bool get _allLessonsCompleted {
    return _lessons.every((l) {
      final progresses = l['LessonProgresses'] as List? ?? [];
      if (progresses.isEmpty) return false;
      return progresses.first['completed'] == true;
    });
  }

  Future<void> _finishCourse() async {
    try {
      await CourseService().completeCourse(widget.courseId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Congratulations! Course finished.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to finish course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final lesson = _lessons[_currentIndex];
    final raw = lesson['video_url'] as String? ?? '';
    final videoUrl = raw.startsWith('http') ? raw : '${ApiService.baseUrl}$raw';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Column(
        children: [
          // Video player
          VideoPlayerWidget(
            key: _videoPlayerKey,
            lessonId: lesson['id'] as int,
            videoUrl: videoUrl,
            hasPrevious: _currentIndex > 0,
            hasNext: _currentIndex < _lessons.length - 1,
            onSkipPrevious: _skipPrevious,
            onSkipNext: _skipNext,
          ),
          const SizedBox(height: 16),
          // Current lesson title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              lesson['name'] ?? 'Lesson',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // Lesson list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final l = _lessons[index];
                final progresses = l['LessonProgresses'] as List? ?? [];
                final progress = progresses.isNotEmpty
                    ? (progresses.first['progress'] as num).toDouble()
                    : 0.0;
                final completed = progresses.isNotEmpty
                    ? progresses.first['completed'] == true
                    : false;
                final quiz = l['Quiz'] as Map<String, dynamic>?;
                final questions = (quiz?['Questions'] as List?)
                        ?.map((q) => Map<String, dynamic>.from(q))
                        .toList() ??
                    [];
                final quizResult = l['quizResult'] as Map<String, dynamic>?;
                final score = quizResult?['score'] as int?;
                final quizDone = quizResult != null;

                // highlight if this is the current lesson
                final cardColor =
                    index == _currentIndex ? Colors.blue.shade50 : Colors.white;

                return InkWell(
                  onTap: () => _loadLesson(index),
                  child: Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + icon
                          Row(
                            children: [
                              Icon(
                                completed
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: completed ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress bar
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            color: const Color(0xFF4B6FFF),
                          ),
                          const SizedBox(height: 4),
                          Text("${(progress * 100).toInt()}% completed",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          // Quiz row
                          if (questions.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  quizDone ? Icons.quiz : Icons.quiz_outlined,
                                  color: quizDone ? Colors.orange : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  quizDone
                                      ? 'Quiz: $score pts'
                                      : 'Quiz: not attempted',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    _videoPlayerKey.currentState?.pause();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizPage(
                                          lessonId: l['id'] as int,
                                          quizTitle: quiz?['title'] as String,
                                          questions: questions,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Start Quiz'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Finish button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _allLessonsCompleted ? _finishCourse : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: _allLessonsCompleted
                    ? const Color(0xFF4B6FFF)
                    : Colors.grey,
              ),
              child: const Text(
                'Finish Course',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
