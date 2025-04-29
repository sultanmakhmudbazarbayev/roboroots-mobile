import 'package:flutter/material.dart';
import 'package:roboroots/screens/home/activity/activityPage.dart';
import 'package:roboroots/screens/home/certificates/certificatesPage.dart';
import 'package:roboroots/screens/home/lessons/coursePage.dart';
import 'package:roboroots/screens/home/profile/profile_screen.dart';
import 'package:roboroots/screens/home/projects/projectsPage.dart';
import 'package:roboroots/screens/home/payment/paymentsPage.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Base list of search options.
  final List<Map<String, dynamic>> _searchOptions = [
    {"title": "Lessons", "icon": Icons.school},
    {"title": "Projects", "icon": Icons.work},
    {"title": "Certificates", "icon": Icons.card_membership},
    {"title": "Activity", "icon": Icons.timeline},
    {"title": "Payment", "icon": Icons.payment},
  ];

  // Filtered list to display based on user input.
  List<Map<String, dynamic>> _filteredOptions = [];

  @override
  void initState() {
    super.initState();

    // Listen for focus changes.
    _focusNode.addListener(_handleFocusChange);

    // Listen for text changes, trigger re-filtering.
    _searchController.addListener(_handleSearchChanged);
  }

  void _handleFocusChange() {
    // If user has focus and typed something, show suggestions.
    if (_focusNode.hasFocus && _searchController.text.trim().isNotEmpty) {
      setState(() => _showSuggestions = true);
    } else {
      setState(() => _showSuggestions = false);
    }
  }

  void _handleSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredOptions = [];
        _showSuggestions = false;
      });
    } else {
      // Filter options whose title contains the query (case-insensitive).
      final results = _searchOptions.where((option) {
        final title = option['title'].toString().toLowerCase();
        return title.contains(query);
      }).toList();

      setState(() {
        _filteredOptions = results;
        // Show suggestions if there's at least one result and field is in focus.
        _showSuggestions = _focusNode.hasFocus && results.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Navigation based on selected option.
  void _navigateToOption(String option) {
    if (option == "Lessons") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoursesPage()),
      );
    } else if (option == "Projects") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProjectsPage()),
      );
    } else if (option == "Certificates") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CertificatesPage()),
      );
    } else if (option == "Activity") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivityPage()),
      );
    } else if (option == "Payment") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping outside search or suggestions removes focus → hides suggestions.
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          // Main scrollable content.
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 24, // space for the custom header.
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text.
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C1E58),
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar.
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            hintText: "Search for new Knowledge!",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // The rest of your normal UI content...
                const SizedBox(height: 24),

                // Blue cards.
                _buildBlueCard(context, "Lessons",
                    "lib/assets/images/lessons.png", "Your lessons"),
                _buildBlueCard(context, "Projects",
                    "lib/assets/images/projects.png", "Your projects"),
                _buildBlueCard(context, "Certificates",
                    "lib/assets/images/certs.png", "Your certificates"),
                _buildBlueCard(context, "Activity",
                    "lib/assets/images/activity.png", "Platform activity"),
                _buildBlueCard(context, "Payment",
                    "lib/assets/images/payment.png", "Payment methods"),
              ],
            ),
          ),

          // Suggestions panel (only show if _showSuggestions is true).
          if (_showSuggestions)
            Positioned(
              left: 16,
              right: 16,
              top: 90, // position under the search bar
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _filteredOptions.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No matches found..."),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredOptions.length,
                        itemBuilder: (context, index) {
                          final option = _filteredOptions[index];
                          return ListTile(
                            leading: Icon(option['icon'], color: Colors.blue),
                            title: Text(option['title']),
                            onTap: () {
                              // Clear text, remove focus, hide suggestions.
                              _searchController.clear();
                              _focusNode.unfocus();
                              _navigateToOption(option['title']);
                            },
                          );
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build a blue card.
  static Widget _buildBlueCard(
    BuildContext context,
    String title,
    String imagePath,
    String descriptionText,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == "Payment") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentPage()),
          );
        }
        if (title == "Lessons") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoursesPage()),
          );
        }
        if (title == "Projects") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectsPage()),
          );
        }
        if (title == "Certificates") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CertificatesPage()),
          );
        }
        if (title == "Activity") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityPage()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF4B6FFF),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left text.
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          descriptionText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_right_alt, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right image.
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  height: 60,
                  width: 60,
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
