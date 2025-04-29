import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

// A simple model for your GitHub Repos
class GithubRepoProject {
  final String title;
  final String subtitle;
  final String description;
  final String imageLarge;
  final String imageThumb;
  final String githubLink;

  GithubRepoProject({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageLarge,
    required this.imageThumb,
    required this.githubLink,
  });
}

// Mock data: three personal GitHub repositories
final List<GithubRepoProject> myGithubProjects = [
  GithubRepoProject(
    title: "Flutter Helper",
    subtitle: "Mobile App",
    description:
        "A sample mobile application demonstrating best practices in Flutter.",
    imageLarge: "lib/assets/images/git_mobile_app.png",
    imageThumb: "lib/assets/images/git_mobile_app.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  GithubRepoProject(
    title: "Bot Assistant",
    subtitle: "AI Chatbot",
    description:
        "A repository containing an open-source AI Chatbot demonstration.",
    imageLarge: "lib/assets/images/git_ai_chatbot.png",
    imageThumb: "lib/assets/images/git_ai_chatbot.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
  GithubRepoProject(
    title: "Web Analytics",
    subtitle: "Web Dashboard",
    description:
        "A web-based dashboard using a popular JavaScript framework for interactive data.",
    imageLarge: "lib/assets/images/git_web_dash.png",
    imageThumb: "lib/assets/images/git_web_dash.png",
    githubLink: "https://github.com/flutter/flutter",
  ),
];

// Detail page for GitHub repo projects
class GithubRepoDetailPage extends StatelessWidget {
  final GithubRepoProject repo;
  const GithubRepoDetailPage({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          repo.title,
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
            // Large Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                repo.imageLarge,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              repo.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              repo.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              repo.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            // More presentable GitHub button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text("View on GitHub"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Replaces 'primary'
                  foregroundColor: Colors.white, // Replaces 'onPrimary'
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  _launchURL(repo.githubLink);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
