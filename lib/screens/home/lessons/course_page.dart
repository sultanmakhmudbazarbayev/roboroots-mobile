import 'package:flutter/material.dart';
import 'package:roboroots/api/course_service.dart';
import 'package:roboroots/screens/home/lessons/course_lesson_page.dart';
import 'package:roboroots/widgets/banner_ad_widget.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEnrolledCourses();
  }

  Future<void> _fetchEnrolledCourses() async {
    try {
      final result = await CourseService().getEnrolledCourses();
      setState(() {
        _courses = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load courses: $e")));
    }
  }

  /// Calculate course progress by counting lessons
  /// whose LessonProgress.completed == true or progress >= 0.9
  double _calculateProgress(Map<String, dynamic> course) {
    final lessons = course['Lessons'] as List<dynamic>? ?? [];
    if (lessons.isEmpty) return 0.0;

    int completedCount = 0;
    for (final rawLesson in lessons) {
      final lesson = rawLesson as Map<String, dynamic>;
      final progresses = lesson['LessonProgresses'] as List<dynamic>? ?? [];
      if (progresses.isNotEmpty) {
        final record = progresses.first as Map<String, dynamic>;
        final progressValue = (record['progress'] as num?)?.toDouble() ?? 0.0;
        final completedFlag = record['completed'] as bool? ?? false;

        if (completedFlag || progressValue >= 0.9) {
          completedCount++;
        }
      }
    }

    return completedCount / lessons.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4B6FFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      final progress = _calculateProgress(course);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseLessonsPage(
                                courseId: course['id'] as int,
                                courseTitle: course['name'] as String,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['name'] as String? ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          course['description'] as String? ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.school,
                                      size: 40, color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white24,
                                color: Colors.white,
                                minHeight: 6,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${(progress * 100).toInt()}% completed",
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.red.withOpacity(0.3),
                    child: BannerAdWidget(), // no const here
                  ),
                ),
              ],
            ),
    );
  }
}
