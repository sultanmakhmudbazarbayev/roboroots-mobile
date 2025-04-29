import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // Dummy user activity data.
  final List<Map<String, dynamic>> _activities = [
    {
      "title": "Completed Lesson",
      "description": "You finished the lesson 'Flutter for Beginners'.",
      "timestamp": "2023-09-01 10:00 AM",
      "icon": Icons.check_circle,
    },
    {
      "title": "Earned Certificate",
      "description": "You earned a certificate in Flutter Development.",
      "timestamp": "2023-09-02 03:30 PM",
      "icon": Icons.card_membership,
    },
    {
      "title": "Joined a Project",
      "description": "You joined the project 'Daily Productivity'.",
      "timestamp": "2023-09-03 09:00 AM",
      "icon": Icons.group_add,
    },
    {
      "title": "Profile Updated",
      "description": "You updated your profile information.",
      "timestamp": "2023-09-03 11:00 AM",
      "icon": Icons.edit,
    },
    {
      "title": "Completed Lesson",
      "description": "You finished the lesson 'Advanced Flutter'.",
      "timestamp": "2023-09-04 02:00 PM",
      "icon": Icons.check_circle,
    },
  ];

  // Available filters.
  final List<String> _filters = [
    "All",
    "Completed Lesson",
    "Earned Certificate",
    "Joined a Project",
    "Profile Updated"
  ];

  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    // Compute summary counts.
    int completedLessons =
        _activities.where((a) => a['title'] == "Completed Lesson").length;
    int earnedCertificates =
        _activities.where((a) => a['title'] == "Earned Certificate").length;
    int joinedProjects =
        _activities.where((a) => a['title'] == "Joined a Project").length;
    int profileUpdates =
        _activities.where((a) => a['title'] == "Profile Updated").length;

    // Filter activities based on selected filter.
    final List<Map<String, dynamic>> filteredActivities =
        _selectedFilter == "All"
            ? _activities
            : _activities.where((a) => a['title'] == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Activity",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Activity Summary Row.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard("Lessons", completedLessons.toString()),
                _buildSummaryCard(
                    "Certificates", earnedCertificates.toString()),
                _buildSummaryCard("Projects", joinedProjects.toString()),
                _buildSummaryCard("Profile", profileUpdates.toString()),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Filter dropdown.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFilter = newValue;
                  });
                }
              },
              items: _filters
                  .map<DropdownMenuItem<String>>(
                      (filter) => DropdownMenuItem<String>(
                            value: filter,
                            child: Text(filter),
                          ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Timeline of activities.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];
                final bool isLast = index == filteredActivities.length - 1;
                return TimelineTile(
                  icon: activity['icon'],
                  title: activity['title'],
                  description: activity['description'],
                  timestamp: activity['timestamp'],
                  isLast: isLast,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Summary card widget.
  Widget _buildSummaryCard(String label, String count) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String timestamp;
  final bool isLast;

  const TimelineTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator column.
        Container(
          width: 40,
          child: Column(
            children: [
              // Circle with icon.
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              // Connector line.
              if (!isLast)
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey[300],
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Activity details container.
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
