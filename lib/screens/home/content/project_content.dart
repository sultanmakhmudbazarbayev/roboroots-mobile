import 'package:flutter/material.dart';
import 'package:roboroots/mock/open_source_projects_mock.dart';
import 'package:roboroots/mock/github_repos_mock.dart';

// A lightweight structure to unify open-source and GitHub repos for searching.
class _ProjectSearchItem {
  final String title;
  final bool isOpenSource;
  final int index;

  _ProjectSearchItem({
    required this.title,
    required this.isOpenSource,
    required this.index,
  });
}

class ProjectContent extends StatefulWidget {
  const ProjectContent({Key? key}) : super(key: key);

  @override
  State<ProjectContent> createState() => _ProjectContentState();
}

class _ProjectContentState extends State<ProjectContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Combined items from openSourceProjects and myGithubProjects
  late List<_ProjectSearchItem> _allItems;
  List<_ProjectSearchItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _allItems = _buildSearchList();

    // Listen for changes in the search field
    _searchController.addListener(_onSearchChanged);

    // When the user focuses or unfocuses, show/hide suggestions accordingly
    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      if (!hasFocus) {
        // If user taps outside, we hide suggestions
        setState(() => _showSuggestions = false);
      } else {
        // If user focuses on search, show suggestions if there's text
        if (_searchController.text.trim().isNotEmpty) {
          setState(() => _showSuggestions = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Combine both sets of data into a single list for quick substring search
  List<_ProjectSearchItem> _buildSearchList() {
    final List<_ProjectSearchItem> combined = [];

    for (int i = 0; i < openSourceProjects.length; i++) {
      combined.add(
        _ProjectSearchItem(
          title: openSourceProjects[i].title,
          isOpenSource: true,
          index: i,
        ),
      );
    }
    for (int i = 0; i < myGithubProjects.length; i++) {
      combined.add(
        _ProjectSearchItem(
          title: myGithubProjects[i].title,
          isOpenSource: false,
          index: i,
        ),
      );
    }

    return combined;
  }

  // Search logic
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredItems.clear();
        _showSuggestions = false;
      });
    } else {
      final results = _allItems.where((item) {
        return item.title.toLowerCase().contains(query);
      }).toList();

      setState(() {
        _filteredItems = results;
        _showSuggestions = _focusNode.hasFocus && results.isNotEmpty;
      });
    }
  }

  // Tapping a suggestion navigates to the correct detail page
  void _navigateToDetail(_ProjectSearchItem item) {
    // Clear everything
    _searchController.clear();
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);

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

  /// Build the dashed-like block used for "Add New Project".
  Widget _buildAddNewProjectBlock() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement your "create new project" logic here.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Add new project clicked!"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey,
            width: 2,
            // There's no default dashed style in Flutter,
            // so we'll use a solid line as a placeholder.
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, size: 36, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                "Add New Project",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // If user taps outside (anywhere in empty space), we unfocus the search field
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          // Main Content: scrollable page
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (centered)
                const Center(
                  child: Text(
                    "Projects",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(4, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            hintText: "Search for new Projects!",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),

                // "Open-Source Projects"
                Text(
                  "Open-Source Projects",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontally scrollable list of open-source projects
                // (same style as before: 200px wide, 180px tall)
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: openSourceProjects.length,
                    itemBuilder: (context, index) {
                      final project = openSourceProjects[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to open-source project detail
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetailPage(project: project),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: index < openSourceProjects.length - 1
                                ? 16.0
                                : 0,
                          ),
                          width: 200,
                          child: Stack(
                            children: [
                              // Thumbnail image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  project.imageLarge,
                                  width: 200,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient overlay
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Text at bottom-left
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.subtitle,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      project.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // "Your Projects Github Repos"
                Text(
                  "Your Projects Github Repos",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontally scrollable list of GitHub repos
                SizedBox(
                  height: 240, // Increased height to 240
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // We'll add +1 to accommodate the "Add New Project" item.
                    itemCount: myGithubProjects.length + 1,
                    itemBuilder: (context, index) {
                      // If index is beyond the last repo, it's the "Add" block.
                      if (index == myGithubProjects.length) {
                        return _buildAddNewProjectBlock();
                      }

                      final repo = myGithubProjects[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the repo detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GithubRepoDetailPage(repo: repo),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right:
                                  // index < myGithubProjects.length - 1 ? 16.0 : 0,
                                  16),
                          width: 120,
                          child: Stack(
                            children: [
                              // Thumbnail image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  repo.imageThumb,
                                  width: 120,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient overlay
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Text at bottom-left
                              Positioned(
                                left: 8,
                                bottom: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      repo.subtitle,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      repo.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // If user is typing something and has focus, show suggestions container
          if (_showSuggestions && _filteredItems.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              top: 120, // offset from top to place below the search bar
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
                      onTap: () => _navigateToDetail(item),
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
