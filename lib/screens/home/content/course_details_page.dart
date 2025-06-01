import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:roboroots/api/api_service.dart';
import 'package:roboroots/api/course_service.dart';
import 'package:roboroots/screens/home/content/quiz_screen.dart';
import 'package:roboroots/widgets/video_player_widget.dart';

class CourseDetailPage extends StatefulWidget {
  final int courseId;
  const CourseDetailPage({Key? key, required this.courseId}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Map<String, dynamic>? _course;
  List<bool> _expanded = [];
  List<GlobalKey<VideoPlayerWidgetState>> _playerKeys = [];
  bool _enrolled = false;

  @override
  void initState() {
    super.initState();
    _fetchCourse();
  }

  Future<void> _fetchCourse() async {
    final course = await CourseService().getCourseById(widget.courseId);
    final lessons = course['Lessons'] as List<dynamic>? ?? [];
    setState(() {
      _course = course;
      _expanded = List.filled(lessons.length, false);
      _playerKeys = List.generate(lessons.length, (_) => GlobalKey());
    });
  }

  Future<void> _toggleEnroll() async {
    final price = (_course!['price'] as num).toDouble();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enroll Confirmation"),
        content: Text("Enroll for \$${price.toStringAsFixed(2)}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Enroll")),
        ],
      ),
    );
    if (ok == true) {
      await CourseService().enrollInCourse(widget.courseId);
      setState(() => _enrolled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final lessons = _course!['Lessons'] as List<dynamic>;

    return Scaffold(
      appBar:
          AppBar(title: Text(_course!['name']), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_course!['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '${ApiService.baseUrl}${_course!['image']}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          const SizedBox(height: 16),
          Text(_course!['name'],
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_course!['description'],
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 8),
          Text('Price: \$${(_course!['price'] as num).toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green)),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              icon: Icon(_enrolled ? Icons.check : Icons.lock_open),
              label: Text(_enrolled ? "Enrolled" : "Enroll Now"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _enrolled ? Colors.grey : Colors.blue),
              onPressed: _enrolled ? null : _toggleEnroll,
            ),
          ),
          const SizedBox(height: 24),
          const Text("Course Content",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lessons.length,
            itemBuilder: (ctx, i) {
              final lesson = lessons[i] as Map<String, dynamic>;
              final isLocked = !_enrolled && i != 0;
              final isOpen = _expanded[i];
              final quiz = lesson['Quiz'] as Map<String, dynamic>?;

              return Column(children: [
                // video card
                Card(
                  color: isLocked ? Colors.grey.shade200 : null,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(children: [
                    ListTile(
                      leading: Icon(isLocked ? Icons.lock : Icons.play_circle),
                      title: Text(lesson['name']),
                      subtitle: Text(lesson['description'] ?? ''),
                      trailing:
                          Icon(isOpen ? Icons.expand_less : Icons.expand_more),
                      onTap: isLocked
                          ? null
                          : () => setState(() => _expanded[i] = !isOpen),
                    ),
                    if (isOpen &&
                        !isLocked &&
                        (lesson['video_url'] as String?) != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerWidget(
                          key: _playerKeys[i],
                          lessonId: lesson['id'] as int,
                          videoUrl: lesson['video_url'] as String,
                          hasPrevious: false,
                          hasNext: false,
                        ),
                      ),
                  ]),
                ),

                // quiz: only show when index != 0 (i.e. hide for first)
                if (!isLocked &&
                    i != 0 &&
                    quiz != null &&
                    (quiz['Questions'] as List).isNotEmpty)
                  Card(
                    color: Colors.orange.shade100,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.quiz),
                      title: Text(quiz['title']),
                      subtitle:
                          Text("Test your knowledge on “${lesson['name']}”"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(
                                lessonId: lesson['id'] as int,
                                quizTitle: quiz['title'] as String,
                                questions: List<Map<String, dynamic>>.from(
                                    quiz['Questions'] as List),
                              ),
                            ),
                          );
                        },
                        child: const Text("Start Quiz"),
                      ),
                    ),
                  ),
              ]);
            },
          ),
        ]),
      ),
    );
  }
}
