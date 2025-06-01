import 'package:flutter/material.dart';
import 'package:roboroots/api/api_service.dart';
import 'package:roboroots/api/course_service.dart';
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
  List<Map<String, dynamic>> _allCourses = [];
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
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

  Future<void> _fetchCourses() async {
    try {
      final service = CourseService();
      final courses = await service.getAllCourses();
      setState(() => _allCourses = courses);
    } catch (e) {
      debugPrint('Error loading courses: $e');
    }
  }

  void _handleFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    if (!hasFocus) {
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
      final results = _allCourses.where((course) {
        return course['name'].toLowerCase().contains(query) ||
            course['description'].toLowerCase().contains(query);
      }).toList();

      setState(() {
        _filteredCourses = results;
        _showSuggestions = _focusNode.hasFocus && results.isNotEmpty;
      });
    }
  }

  void _navigateToCourse(Map<String, dynamic> course) {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() => _showSuggestions = false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CourseDetailPage(courseId: course['id'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                // "Recommended" - using first 4
                Text(
                  "Recommended for You",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < _allCourses.length && i < 4; i += 2)
                  Row(
                    children: [
                      Expanded(
                          child: _buildRecommendationCard(
                              context, _allCourses[i])),
                      const SizedBox(width: 16),
                      if (i + 1 < _allCourses.length)
                        Expanded(
                            child: _buildRecommendationCard(
                                context, _allCourses[i + 1]))
                      else
                        const Spacer(),
                    ],
                  ),
                const SizedBox(height: 24),

                Text(
                  "Top Searches",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _allCourses.length,
                    itemBuilder: (context, index) {
                      return _buildHorizontalItem(context, _allCourses[index]);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Center(child: BannerAdWidget()),
                const SizedBox(height: 24),
              ],
            ),
          ),
          if (_showSuggestions && _filteredCourses.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              top: 120,
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
                      title: Text(c['name']),
                      subtitle: Text(c['description']),
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

  Widget _buildRecommendationCard(
      BuildContext context, Map<String, dynamic> course) {
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
              Expanded(
                flex: 3,
                child: Image.network(
                  '${ApiService.baseUrl}${course['image']}', // optionally prefix with BASE_URL
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.blue.shade50,
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      const SizedBox(height: 4),
                      Text(course['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          )),
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

  Widget _buildHorizontalItem(
      BuildContext context, Map<String, dynamic> course) {
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
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  '${ApiService.baseUrl}${course['image']}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(course['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(course['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        )),
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
