import 'package:flutter/material.dart';
import 'package:roboroots/screens/auth/sign_in_screen.dart';
import 'package:roboroots/screens/home/content/notification_screen.dart';
import 'package:roboroots/screens/home/lessons/coursePage.dart';
import 'package:roboroots/screens/home/payment/paymentsPage.dart';
import 'package:roboroots/screens/home/profile/profile_screen.dart';

class MenuContent extends StatelessWidget {
  const MenuContent({Key? key}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close the dialog
                // Navigate to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  // Presentable Help & Support modal.
  void _showHelpSupportModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // Ensures the dialog sizes to its contents.
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.help_outline,
                  size: 60,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "If you need assistance, please try the following:\n\n• Check our FAQ page for common questions.\n• Email our support team at support@example.com.\n• Call us at +1 (555) 123-4567.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Profile Shortcuts
          Text(
            "Profile Shortcuts",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Row with some "shortcut" cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShortcutCard("Settings", Icons.settings),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                child: _buildShortcutCard("Account", Icons.person_outline),
              ),

              // Wrap the Notifications card in a GestureDetector
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                child: _buildShortcutCard(
                    "Notifications", Icons.notifications_none),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Menu Items
          Text(
            "Main Menu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Menu blocks with navigation:
          _buildMenuBlock(
            context,
            "My Courses",
            Icons.menu_book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CoursesPage()),
              );
            },
          ),
          _buildMenuBlock(
            context,
            "Payments",
            Icons.credit_card,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentPage()),
              );
            },
          ),
          _buildMenuBlock(
            context,
            "Help & Support",
            Icons.help_outline,
            onTap: () => _showHelpSupportModal(context),
          ),
          _buildMenuBlock(
            context,
            "Log Out",
            Icons.exit_to_app,
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // A small "shortcut" card with an icon and label.
  Widget _buildShortcutCard(String label, IconData icon) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.blueGrey),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // A larger menu block with an icon on the left and text.
  // Added an optional onTap callback.
  Widget _buildMenuBlock(BuildContext context, String title, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blueGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
