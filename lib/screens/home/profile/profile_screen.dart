import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0; // for bottom nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back arrow and notification bell
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back navigation
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Profile Avatar
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: Center(
                // Replace with your actual avatar image
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name and subtitle
            const Text(
              "Ainur",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "LEVEL 10\nStudent",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Followers & Following
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Followers
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Followers",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "478",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Following
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Following",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "36",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Achievements Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Achievements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Achievements in a Grid or multiple rows
            // For example, 2 achievements per row
            Row(
              children: [
                Expanded(
                  child: _buildAchievementBlock(
                    icon: Icons.card_membership,
                    label: "Certificates\nEarned",
                    value: "4",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAchievementBlock(
                    icon: Icons.build_circle_outlined,
                    label: "Projects\nCompleted",
                    value: "2",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAchievementBlock(
                    icon: Icons.whatshot,
                    label: "Current\nStreak",
                    value: "7 Days",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAchievementBlock(
                    icon: Icons.stars,
                    label: "Mastery\nLevel",
                    value: "10",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper to build an achievement block
  Widget _buildAchievementBlock({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
