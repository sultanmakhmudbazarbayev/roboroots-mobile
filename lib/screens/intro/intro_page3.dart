import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center the entire content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            // Logo at the top
            Image.asset(
              'lib/assets/images/robot_logo.png', // Your logo path here
              height: 150, // Adjust as needed
            ),
            SizedBox(height: 30),
            // Title text
            Text(
              "Learn From Home",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // You can change the color if needed
              ),
            ),
            SizedBox(height: 10),
            // Description text
            Text(
              "You can learn from anywhere!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
