import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    );
  }
}
