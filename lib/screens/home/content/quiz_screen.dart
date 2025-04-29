import 'package:flutter/material.dart';
import 'package:roboroots/mock/course_data_mock.dart';

class QuizPage extends StatefulWidget {
  final String quizTitle;
  final List<QuizQuestion> questions;

  const QuizPage({Key? key, required this.quizTitle, required this.questions})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<int> _selectedAnswers;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int>.filled(widget.questions.length, -1);
  }

  void _submitQuiz() {
    setState(() {
      _submitted = true;
    });
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_selectedAnswers[i] == widget.questions[i].correctOptionIndex) {
        score++;
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Result"),
        content: Text("Your score: $score / ${widget.questions.length}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final question = widget.questions[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}: ${question.question}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(question.options.length, (optionIndex) {
                bool isSelected = _selectedAnswers[index] == optionIndex;
                bool isCorrect = question.correctOptionIndex == optionIndex;
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
                  value: optionIndex,
                  groupValue: _selectedAnswers[index],
                  onChanged: _submitted
                      ? null
                      : (value) {
                          setState(() {
                            _selectedAnswers[index] = value!;
                          });
                        },
                  title: Text(question.options[optionIndex]),
                  tileColor: tileColor,
                );
              }),
            )
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
            ...List.generate(
                widget.questions.length, (index) => _buildQuestion(index)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitted ? null : _submitQuiz,
              child: const Text("Submit Quiz"),
            )
          ],
        ),
      ),
    );
  }
}
