import 'package:flutter/material.dart';
import 'package:roboroots/api/course_service.dart';

class QuizPage extends StatefulWidget {
  final int lessonId;
  final String quizTitle;
  final List<dynamic> questions;

  const QuizPage({
    Key? key,
    required this.lessonId,
    required this.quizTitle,
    required this.questions,
  }) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<int> _selectedAnswers;
  bool _submitted = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int>.filled(widget.questions.length, -1);
  }

  Future<void> _submitQuiz() async {
    setState(() => _submitted = true);

    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i] as Map<String, dynamic>;
      final answers = question['Answers'] as List<dynamic>;
      final correctIndex = answers.indexWhere((a) => a['is_correct'] == true);
      if (_selectedAnswers[i] == correctIndex) score++;
    }
    setState(() => _score = score);

    // send result to backend
    try {
      await CourseService().submitQuizResult(widget.lessonId, _score);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save result: $e')),
      );
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Result'),
        content: Text('Your score: $_score / ${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final question = widget.questions[index] as Map<String, dynamic>;
    final answers = question['Answers'] as List<dynamic>;
    final correctIndex = answers.indexWhere((a) => a['is_correct'] == true);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}: ${question['text']}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(answers.length, (optIndex) {
              final isSelected = _selectedAnswers[index] == optIndex;
              final isCorrect = correctIndex == optIndex;
              Color? tileColor;
              if (_submitted) {
                if (isSelected) {
                  tileColor =
                      isCorrect ? Colors.green.shade100 : Colors.red.shade100;
                } else if (isCorrect) {
                  tileColor = Colors.green.shade100;
                }
              }
              return RadioListTile<int>(
                value: optIndex,
                groupValue: _selectedAnswers[index],
                onChanged: _submitted
                    ? null
                    : (v) => setState(() => _selectedAnswers[index] = v!),
                title: Text(answers[optIndex]['text'] as String),
                tileColor: tileColor,
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.quizTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var i = 0; i < widget.questions.length; i++) _buildQuestion(i),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitted ? null : _submitQuiz,
              child: const Text('Submit Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
