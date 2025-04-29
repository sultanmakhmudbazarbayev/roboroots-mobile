// course_lessons_page.dart
import 'package:flutter/material.dart';
import 'package:roboroots/widgets/video_player_widget.dart'; // new file with our widget
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CourseLessonsPage extends StatefulWidget {
  final String courseTitle;
  const CourseLessonsPage({Key? key, required this.courseTitle})
      : super(key: key);

  @override
  State<CourseLessonsPage> createState() => _CourseLessonsPageState();
}

class _CourseLessonsPageState extends State<CourseLessonsPage> {
  // Dummy lessons data with sample video URLs.
  final List<Map<String, dynamic>> lessons = const [
    {
      'title': '1. Introduction',
      'progress': 1.0, // Completed
      'duration': "00:15",
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
    {
      'title': '2. Widgets 101',
      'progress': 0.5, // 50% complete
      'duration': "09:56",
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
    {
      'title': '3. State Management',
      'progress': 0.0, // Not started
      'duration': "01:00",
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    },
  ];

  int currentIndex = 0;
  final GlobalKey<VideoPlayerWidgetState> _videoPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  /// Moves to the previous lesson if any.
  void _skipPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      final url = lessons[currentIndex]['videoUrl'] as String;
      _videoPlayerKey.currentState?.loadVideoUrl(url);
    }
  }

  /// Moves to the next lesson if any.
  void _skipNext() {
    if (currentIndex < lessons.length - 1) {
      setState(() => currentIndex++);
      final url = lessons[currentIndex]['videoUrl'] as String;
      _videoPlayerKey.currentState?.loadVideoUrl(url);
    }
  }

  /// When a user taps a lesson in the list, re-load that video.
  void _loadLesson(int index) {
    setState(() => currentIndex = index);
    final url = lessons[index]['videoUrl'] as String;
    _videoPlayerKey.currentState?.loadVideoUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final lessonTitle = lessons[currentIndex]['title'] as String;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.courseTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Column(
        children: [
          // The separated video player widget (with skipping).
          VideoPlayerWidget(
            key: _videoPlayerKey,
            videoUrl: lessons[currentIndex]['videoUrl'],
            hasPrevious: currentIndex > 0,
            hasNext: currentIndex < lessons.length - 1,
            onSkipPrevious: _skipPrevious,
            onSkipNext: _skipNext,
          ),
          const SizedBox(height: 16),
          // Display the title of the currently playing video.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              lessonTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          // Lessons list below the video player.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return GestureDetector(
                  onTap: () => _loadLesson(index),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row with circular checkbox, lesson title, and duration.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    lesson['progress'] == 1.0
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: lesson['progress'] == 1.0
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    lesson['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                lesson['duration'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: lesson['progress'],
                            backgroundColor: Colors.grey[300],
                            color: const Color(0xFF4B6FFF),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${(lesson['progress'] * 100).toInt()}% completed",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
