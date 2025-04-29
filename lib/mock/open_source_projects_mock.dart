import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A helper method to launch a URL in the browser.
Future<void> _launchURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}

/// Model representing an open-source project (now with GitHub link).
class OpenSourceProject {
  final String title;
  final String subtitle;
  final String description;
  final String imageLarge;
  final String githubLink; // NEW field for GitHub link

  OpenSourceProject({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageLarge,
    required this.githubLink,
  });
}

/// Mock data: five open-source projects with images + GitHub links
final List<OpenSourceProject> openSourceProjects = [
  OpenSourceProject(
    title: "UI/UX Basics",
    subtitle: "Introduction to Design",
    description:
        "Learn the fundamentals of UI and UX design with essential principles and best practices.",
    imageLarge: "lib/assets/images/project_uiux.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  OpenSourceProject(
    title: "Coding for Robots",
    subtitle: "Basics of Robotics",
    description:
        "Explore programming and controlling robotics systems using open-source hardware and software.",
    imageLarge: "lib/assets/images/project_robotics.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  OpenSourceProject(
    title: "E-Commerce",
    subtitle: "Web Shop",
    description:
        "Build an online store from scratch with open-source e-commerce solutions and frameworks.",
    imageLarge: "lib/assets/images/project_ecommerce.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  OpenSourceProject(
    title: "Machine Learning",
    subtitle: "Beginner Project",
    description:
        "A beginner-friendly project showing basic ML algorithms, data preparation, and deployment.",
    imageLarge: "lib/assets/images/project_ml.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  OpenSourceProject(
    title: "Mobile Banking App",
    subtitle: "Fintech Demo",
    description:
        "An open-source fintech application demonstrating mobile banking features and security best practices.",
    imageLarge: "lib/assets/images/project_fintech.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
];

/// Detail page for an OpenSourceProject
class ProjectDetailPage extends StatelessWidget {
  final OpenSourceProject project;
  const ProjectDetailPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          project.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Large Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                project.imageLarge,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            /// Title
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// Subtitle
            Text(
              project.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            /// Description
            Text(
              project.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            /// "View on GitHub" button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text("View on GitHub"),
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
                onPressed: () {
                  _launchURL(project.githubLink);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
