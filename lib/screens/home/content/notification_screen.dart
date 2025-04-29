import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  // Dummy notifications data.
  final List<Map<String, String>> notifications = const [
    {
      "title": "New Course Available",
      "message": "Check out our latest course on Advanced Flutter techniques.",
      "time": "2 hours ago",
    },
    {
      "title": "Payment Successful",
      "message": "Your payment for 'Flutter for Beginners' has been processed.",
      "time": "1 day ago",
    },
    {
      "title": "Reminder",
      "message": "Don't forget to continue your 'Advanced Flutter' course.",
      "time": "2 days ago",
    },
    {
      "title": "Update Available",
      "message": "New content has been added to your favorite course.",
      "time": "3 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: const Icon(
                Icons.notifications,
                size: 40,
                color: Colors.blue,
              ),
              title: Text(
                notification["title"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification["message"] ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification["time"] ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
