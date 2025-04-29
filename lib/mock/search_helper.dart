import 'package:roboroots/mock/open_source_projects_mock.dart';
import 'package:roboroots/mock/github_repos_mock.dart';

/// A small struct that stores a project's title, which list it belongs to,
/// and the index in that list. This lets us easily navigate to the correct detail.
class ProjectSearchItem {
  final String title;
  final bool
      isOpenSource; // true for openSourceProjects, false for myGithubProjects
  final int index;

  ProjectSearchItem({
    required this.title,
    required this.isOpenSource,
    required this.index,
  });
}

/// Builds a combined list of all project titles from openSourceProjects & myGithubProjects.
List<ProjectSearchItem> buildSearchList() {
  final List<ProjectSearchItem> combined = [];

  // Add open-source projects
  for (int i = 0; i < openSourceProjects.length; i++) {
    combined.add(
      ProjectSearchItem(
        title: openSourceProjects[i].title,
        isOpenSource: true,
        index: i,
      ),
    );
  }

  // Add GitHub repos
  for (int i = 0; i < myGithubProjects.length; i++) {
    combined.add(
      ProjectSearchItem(
        title: myGithubProjects[i].title,
        isOpenSource: false,
        index: i,
      ),
    );
  }

  return combined;
}
