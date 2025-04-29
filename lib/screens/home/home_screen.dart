import 'package:flutter/material.dart';
import 'package:roboroots/screens/home/chatbot/chatbot.dart';
import 'package:roboroots/screens/home/content/project_content.dart';
import 'package:roboroots/screens/home/content/menu_settings_content.dart';
import 'package:roboroots/screens/home/content/course_content.dart';
import 'package:roboroots/screens/home/profile/profile_screen.dart';
import 'package:roboroots/widgets/custom_bottom_navbar.dart';
import 'package:roboroots/widgets/custom_header.dart'; // <— import the header
import 'home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Pages for each tab index:
  final List<Widget> _pages = [
    const HomeContent(),
    const ProjectContent(),
    const ChatbotScreen(),
    const CourseContent(),
    const MenuContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Instead of body: _pages[_currentIndex], we use a Stack
      body: Stack(
        children: [
          // The main page content, with top margin so it doesn't overlap the header
          Container(
            margin: const EdgeInsets.only(top: 90.0),
            // You can adjust top: 90.0 to match your header's height
            child: _pages[_currentIndex],
          ),

          // The custom header sitting on top
          CustomHeader(
            onBrandIconTap: () {
              // e.g., open a side menu or show a dialog
              debugPrint("Brand icon tapped!");
            },
            onAvatarTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      // Floating Action Button (center-docked)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // handle FAB tap
      //   },
      //   backgroundColor: Colors.blue,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
