import 'package:flutter/material.dart';
import 'package:roboroots/mock/open_source_projects_mock.dart';
import 'package:roboroots/mock/github_repos_mock.dart';
import 'search_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showSuggestions = false;
  late List<ProjectSearchItem> _allItems;
  List<ProjectSearchItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    // Build the combined list once
    _allItems = buildSearchList();

    // Listen for changes in text & focus
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      setState(() {
        // Show suggestions if the field is focused & there's a query
        _showSuggestions =
            _focusNode.hasFocus && _searchController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredItems = [];
        _showSuggestions = false;
      });
    } else {
      // Filter the list by matching substring
      final results = _allItems.where((item) {
        return item.title.toLowerCase().contains(query);
      }).toList();

      setState(() {
        _filteredItems = results;
        // Show suggestions if field is in focus
        _showSuggestions = _focusNode.hasFocus;
      });
    }
  }

  /// Navigate to detail page based on item.isOpenSource
  void _navigateToProject(ProjectSearchItem item) {
    if (item.isOpenSource) {
      // It's an open-source project
      final project = openSourceProjects[item.index];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProjectDetailPage(project: project)),
      );
    } else {
      // It's a GitHub repo
      final repo = myGithubProjects[item.index];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GithubRepoDetailPage(repo: repo)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Projects"),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        // Tapping anywhere outside removes focus
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Main content (Search bar + placeholder text)
            _buildMainContent(),
            // Suggestions overlay
            if (_showSuggestions && _filteredItems.isNotEmpty)
              Positioned(
                left: 16,
                right: 16,
                top: 100, // space below the search bar
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
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item.title),
                        onTap: () {
                          // Clear & hide suggestions
                          setState(() {
                            _searchController.clear();
                            _showSuggestions = false;
                          });
                          _focusNode.unfocus();

                          // Go to detail page
                          _navigateToProject(item);
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: "Search from existing projects...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // Some placeholder content
        const Expanded(
          child: Center(
            child: Text(
              "Type to search for existing open-source projects or GitHub repos.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
