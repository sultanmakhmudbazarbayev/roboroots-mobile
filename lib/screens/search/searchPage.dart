import 'package:flutter/material.dart';
import 'package:roboroots/screens/home/activity/activityPage.dart';
import 'package:roboroots/screens/home/certificates/certificatesPage.dart';
import 'package:roboroots/screens/home/lessons/coursePage.dart';
import 'package:roboroots/screens/home/projects/projectsPage.dart';
import 'package:roboroots/screens/home/payment/paymentsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // List of search options with a title and an icon.
  final List<Map<String, dynamic>> _searchOptions = const [
    {
      "title": "Lessons",
      "icon": Icons.school,
    },
    {
      "title": "Projects",
      "icon": Icons.work,
    },
    {
      "title": "Certificates",
      "icon": Icons.card_membership,
    },
    {
      "title": "Activity",
      "icon": Icons.timeline,
    },
    {
      "title": "Payment",
      "icon": Icons.payment,
    },
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Navigation method based on the selected option.
  void _navigateToOption(String option) {
    if (option == "Lessons") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CoursesPage()));
    } else if (option == "Projects") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProjectsPage()));
    } else if (option == "Certificates") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CertificatesPage()));
    } else if (option == "Activity") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ActivityPage()));
    } else if (option == "Payment") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PaymentPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Column(
        children: [
          // Search bar with a light gray background.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for new Knowledge!",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
            ),
          ),
          // Suggestions panel appears when the search field is focused.
          if (_showSuggestions)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                // You can adjust decoration as needed.
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ListView.builder(
                  itemCount: _searchOptions.length,
                  itemBuilder: (context, index) {
                    final option = _searchOptions[index];
                    return ListTile(
                      leading: Icon(option['icon'], color: Colors.blue),
                      title: Text(option['title']),
                      onTap: () {
                        // Clear the search field and unfocus to hide suggestions.
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
}
