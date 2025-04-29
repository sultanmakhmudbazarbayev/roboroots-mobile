import 'package:flutter/material.dart';
import 'package:roboroots/mock/course_data_mock.dart';
import 'package:roboroots/screens/home/content/course_details_page.dart';
import 'package:roboroots/widgets/banner_ad_widget.dart';

class CourseContent extends StatefulWidget {
  const CourseContent({Key? key}) : super(key: key);

  @override
  State<CourseContent> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showSuggestions = false;
  late List<Course> _allCourses; // combined from recommended & topSearch
  List<Course> _filteredCourses = []; // matches the user’s search text

  @override
  void initState() {
    super.initState();
    // Combine recommended and topSearch courses into one list.
    _allCourses = [...recommendedCourses, ...topSearchCourses];

    // Listen for text changes & focus changes
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_handleFocusChange);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    if (!hasFocus) {
      // If user taps outside, hide suggestions.
      setState(() => _showSuggestions = false);
    } else if (_searchController.text.trim().isNotEmpty) {
      setState(() => _showSuggestions = true);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCourses.clear();
        _showSuggestions = false;
      });
    } else {
      // Filter courses by title or subtitle matching the query.
      final results = _allCourses.where((course) {
        final t = course.title.toLowerCase();
        final s = course.subtitle.toLowerCase();
        return t.contains(query) || s.contains(query);
      }).toList();

      setState(() {
        _filteredCourses = results;
        _showSuggestions = _focusNode.hasFocus && results.isNotEmpty;
      });
    }
  }

  void _navigateToCourse(Course course) {
    // Clear search & hide suggestions.
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() => _showSuggestions = false);

    // Navigate to course details.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping outside the search field/suggestions unfocuses search.
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          // Main scrollable content.
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (centered).
                const Center(
                  child: Text(
                    "Courses",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Search bar.
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
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
                            hintText:
                                "Search for courses, lessons, or teachers",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),

                // "Recommended for You" section.
                Text(
                  "Recommended for You",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // Display 2 recommended blocks per row.
                for (int i = 0; i < recommendedCourses.length; i += 2)
                  Row(
                    children: [
                      Expanded(
                        child: _buildRecommendationCard(
                          context,
                          recommendedCourses[i],
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (i + 1 < recommendedCourses.length)
                        Expanded(
                          child: _buildRecommendationCard(
                            context,
                            recommendedCourses[i + 1],
                          ),
                        )
                      else
                        const Spacer(),
                    ],
                  ),
                const SizedBox(height: 24),

                // "Top Searches" section.
                Text(
                  "Top Searches",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontal list of topSearchCourses.
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topSearchCourses.length,
                    itemBuilder: (context, index) {
                      final course = topSearchCourses[index];
                      return _buildHorizontalItem(context, course);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Insert BannerAdWidget here.
                Center(child: BannerAdWidget()),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Suggestions overlay.
          if (_showSuggestions && _filteredCourses.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              top: 120, // Position below the search bar.
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
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, index) {
                    final c = _filteredCourses[index];
                    return ListTile(
                      title: Text(c.title),
                      subtitle: Text(c.subtitle),
                      onTap: () => _navigateToCourse(c),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // A recommendation card with image on top, text below.
  Widget _buildRecommendationCard(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () => _navigateToCourse(course),
      child: Container(
        height: 220,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top: Image.
              Expanded(
                flex: 3,
                child: Image.asset(
                  course.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // Bottom: Text info.
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A horizontal item block for "top searches."
  Widget _buildHorizontalItem(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () => _navigateToCourse(course),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top image.
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  course.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Bottom text.
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      course.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
