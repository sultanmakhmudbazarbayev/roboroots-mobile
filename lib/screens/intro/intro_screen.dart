import 'package:flutter/material.dart';
import 'package:roboroots/screens/intro/intro_page2.dart';
import 'package:roboroots/screens/intro/intro_page3.dart';
import 'intro_page1.dart';
import 'package:roboroots/screens/auth/login_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skipIntro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipIntro,
            child: Text(
              "Skip",
              style: TextStyle(
                color: Color.fromARGB(255, 21, 132, 223),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          // This Row will hold both the page indicator dots and the arrow button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Distribute the dots and button across the width
              children: [
                // Dots on the left
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: _currentPage == index ? 20 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Color.fromARGB(255, 21, 132, 223)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                // Arrow button on the right with "Get Started" text
                _currentPage == 2 // Check if we're on the last page
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen()), // Add your next screen here
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 21, 132,
                              223), // Correct way to set background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          minimumSize: Size(150,
                              60), // Set the minimum size of the button to avoid shrinking
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Keeps the text and arrow together
                          children: [
                            // Animated opacity for the "Get Started" text
                            AnimatedOpacity(
                              opacity: _currentPage == 2 ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 1500),
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 60, // Set the height of the circle button
                        width: 60, // Set the width of the circle button
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 21, 132, 223),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          iconSize: 30, // Adjust icon size
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
