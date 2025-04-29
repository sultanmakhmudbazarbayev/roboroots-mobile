import 'package:flutter/material.dart';
import 'package:roboroots/mock/course_data_mock.dart';
import 'package:roboroots/screens/home/content/quiz_screen.dart';
import 'package:roboroots/widgets/video_player_widget.dart'; // Make sure this file exists and implements VideoPlayerWidget

class CourseDetailPage extends StatefulWidget {
  final Course course;
  const CourseDetailPage({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  // Expanded state for each section (only applicable for lessons).
  late List<bool> _expanded;
  // A VideoPlayerWidget key per section (only used for lessons).
  late List<GlobalKey<VideoPlayerWidgetState>> _playerKeys;

  @override
  void initState() {
    super.initState();
    // Initialize expansion for each section. For quiz sections, this value is ignored.
    _expanded = List.filled(widget.course.sections.length, false);
    // Create a global key for each section (unused for quiz sections).
    _playerKeys = List.generate(
      widget.course.sections.length,
      (index) => GlobalKey<VideoPlayerWidgetState>(),
    );
  }

  void _startQuiz(String quizTitle) {
    // Look up the quiz questions by quizTitle in quizMockData.
    final quizQuestions = quizMockData[quizTitle];
    if (quizQuestions != null) {
      // Navigate to the quiz screen with the found questions.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPage(
            quizTitle: quizTitle,
            questions: quizQuestions,
          ),
        ),
      );
    } else {
      // If no quiz data is found, show a SnackBar or any other error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quiz data for '$quizTitle' not found."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.course.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image & info
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.course.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.course.subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              widget.course.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              "Course Sections",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // List of course sections (lessons and quizzes)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.course.sections.length,
              itemBuilder: (context, index) {
                final section = widget.course.sections[index];
                if (section.type == CourseSectionType.lesson) {
                  // Lesson section with expandable video player.
                  final isOpen = _expanded[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(section.title),
                          subtitle: Text(section.description),
                          leading: const Icon(Icons.play_circle_fill),
                          trailing: Icon(
                            isOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          ),
                          onTap: () {
                            setState(() {
                              _expanded[index] = !_expanded[index];
                            });
                          },
                        ),
                        if (isOpen)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayerWidget(
                              key: _playerKeys[index],
                              videoUrl: section.videoUrl!,
                              hasPrevious: false,
                              hasNext: false,
                            ),
                          ),
                      ],
                    ),
                  );
                } else if (section.type == CourseSectionType.quiz) {
                  // Quiz section card.
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Colors.orange.shade100,
                    child: ListTile(
                      title: Text(section.title),
                      subtitle: Text(section.description),
                      leading: const Icon(Icons.quiz),
                      trailing: ElevatedButton(
                        child: const Text("Start Quiz"),
                        onPressed: () => _startQuiz(section.title),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
