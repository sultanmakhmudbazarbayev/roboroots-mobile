import 'package:flutter/material.dart';
// Uncomment the following lines if you want to launch URLs.
// import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  // Dummy project data.
  final List<Map<String, dynamic>> projects = const [
    {
      "title": "Daily Productivity",
      "description": "A revolutionary mobile app for daily productivity.",
      "image": "lib/assets/images/project_alpha.png",
      "author": "John Doe",
      "contributors": ["Alice", "Bob"],
      "createdDate": "2023-01-01",
      "lastUpdated": "2023-04-15",
      "progress": 0.8,
      "githubUrl": "https://github.com/example/project-alpha",
      "fields": ["Mobile App", "Productivity"]
    },
    {
      "title": "Robust EComm",
      "description": "A robust web application for e-commerce solutions.",
      "image": "lib/assets/images/project_beta.png",
      "author": "Jane Smith",
      "contributors": ["Charlie", "Dave", "Eve"],
      "createdDate": "2022-10-05",
      "lastUpdated": "2023-03-10",
      "progress": 0.5,
      "githubUrl": "https://github.com/example/project-beta",
      "fields": ["Web App", "E-Commerce"]
    },
    {
      "title": "Gamma Automation",
      "description":
          "An automation and DevOps platform for continuous integration.",
      "image": "lib/assets/images/project_gamma.png",
      "author": "Michael Brown",
      "contributors": ["Fiona", "George"],
      "createdDate": "2021-07-20",
      "lastUpdated": "2023-01-25",
      "progress": 0.65,
      "githubUrl": "https://github.com/example/project-gamma",
      "fields": ["DevOps", "Automation"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Projects",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectCard(project: project);
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectCard({Key? key, required this.project}) : super(key: key);

  // Uncomment and use this method if you add url_launcher to your project.
  // void _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project title, image, and description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    project['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover, // Change to BoxFit.contain if needed.
                  ),
                ),
                const SizedBox(width: 16),
                // Project title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Author and Contributors row
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Author: ${project['author']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.group, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "Contributors: ${project['contributors'].join(", ")}",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Created and Last Updated dates row
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Created: ${project['createdDate']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.update, size: 16),
                const SizedBox(width: 4),
                Text(
                  "Updated: ${project['lastUpdated']}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Work progress tracking
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Progress",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: project['progress'],
                  backgroundColor: Colors.grey[300],
                  color: const Color(0xFF4B6FFF),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  "${(project['progress'] * 100).toInt()}% completed",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // GitHub link and project fields
            Row(
              children: [
                // GitHub repo link
                GestureDetector(
                  onTap: () {
                    // Uncomment the following line if using url_launcher.
                    // _launchURL(project['githubUrl']);
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.code, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        "GitHub Repo",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Project fields as chips
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: (project['fields'] as List<dynamic>)
                      .map<Widget>(
                        (field) => Chip(
                          label: Text(
                            field,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
