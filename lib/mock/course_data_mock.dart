import 'package:flutter/material.dart';

/// Enum to distinguish between a lesson and a quiz.
enum CourseSectionType { lesson, quiz }

/// Represents a course section which can be either a lesson or a quiz.
class CourseSection {
  final CourseSectionType type;
  final String title;
  final String description;
  final String? videoUrl; // Only applicable if type is lesson

  CourseSection({
    required this.type,
    required this.title,
    required this.description,
    this.videoUrl,
  });
}

/// Represents a course with multiple sections (lessons and quizzes).
class Course {
  final String title;
  final String subtitle;
  final String imagePath;
  final String description;
  final List<CourseSection> sections;

  Course({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.description,
    required this.sections,
  });
}

/// Model for quiz question.
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}

/// Quiz mock data keyed by quiz title.
final Map<String, List<QuizQuestion>> quizMockData = {
  "Quiz: UI/UX Basics": [
    QuizQuestion(
      question: "What does UI stand for?",
      options: [
        "User Interface",
        "Universal Interface",
        "User Interaction",
        "Ultimate Interface"
      ],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "What does UX stand for?",
      options: [
        "User Experience",
        "Unified Experience",
        "User Excitement",
        "Unique Experience"
      ],
      correctOptionIndex: 0,
    ),
  ],
  "Quiz: Robotics Intro": [
    QuizQuestion(
      question: "What is robotics?",
      options: [
        "The study of robots",
        "A type of machine",
        "A computer language",
        "None of the above"
      ],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      question: "Which is an example of a robotics platform?",
      options: [
        "Lego Mindstorms",
        "Arduino",
        "Raspberry Pi",
        "All of the above"
      ],
      correctOptionIndex: 3,
    ),
  ],
  "Quiz: Implicit Animations": [
    QuizQuestion(
      question: "What is an implicit animation in Flutter?",
      options: [
        "An animation that automatically interpolates values",
        "An animation that requires manual control",
        "An animation without any transition",
        "None of the above"
      ],
      correctOptionIndex: 0,
    ),
  ],
  "Quiz: React Native Basics": [
    QuizQuestion(
      question: "Which language is primarily used in React Native?",
      options: ["Java", "Kotlin", "JavaScript", "Dart"],
      correctOptionIndex: 2,
    ),
  ],
  "Quiz: Python Basics": [
    QuizQuestion(
      question: "Which of the following is a Python data type?",
      options: ["List", "Dictionary", "Tuple", "All of the above"],
      correctOptionIndex: 3,
    ),
  ],
  "Quiz: Stateless vs Stateful": [
    QuizQuestion(
      question: "Which widget does not maintain state?",
      options: [
        "StatefulWidget",
        "StatelessWidget",
        "InheritedWidget",
        "Container"
      ],
      correctOptionIndex: 1,
    ),
  ],
  "Quiz: AI Fundamentals": [
    QuizQuestion(
      question: "What does AI stand for?",
      options: [
        "Artificial Intelligence",
        "Automated Information",
        "Advanced Internet",
        "None of the above"
      ],
      correctOptionIndex: 0,
    ),
  ],
  "Quiz: Arrays & Lists": [
    QuizQuestion(
      question: "Which data structure is ordered and indexed?",
      options: ["Array", "Graph", "Tree", "HashMap"],
      correctOptionIndex: 0,
    ),
  ],
};

/// Four mock courses for "Recommended for You".
final List<Course> recommendedCourses = [
  Course(
    title: "UI/UX Design",
    subtitle: "Crash Course",
    imagePath: "lib/assets/images/project_uiux.png",
    description: "Learn the fundamentals of UI/UX in this crash course.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Introduction to UI/UX",
        description: "Overview of UI/UX principles.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: UI/UX Basics",
        description: "Test your knowledge on the fundamentals of UI/UX.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Color Theory Basics",
        description: "Understanding color theory and its applications.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      ),
    ],
  ),
  Course(
    title: "Robot Basics",
    subtitle: "Lego Mindstorms",
    imagePath: "lib/assets/images/project_robotics.png",
    description: "Start your robotics journey with Lego Mindstorms.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Getting Started with Robotics",
        description: "Introduction to robotics basics.",
        videoUrl: "https://robo.responcy.net/videos/robotics_1_compressed.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Robotics Intro",
        description: "Test your understanding of robotics basics.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Robotics Tutorial for Beginners",
        description: "How to build an Arduino Robot.",
        videoUrl: "https://robo.responcy.net/videos/robotics_2_compressed.mp4",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Sensors Explained",
        description: "Learn about different types of sensors.",
        videoUrl: "https://robo.responcy.net/videos/robotics_3_compressed.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Sensors and Motors",
        description: "Assess your knowledge on sensors and motors.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Different Types of Motors",
        description: "Explore various motors used in DIY Robotics.",
        videoUrl: "https://robo.responcy.net/videos/robotics_4_compressed.mp4",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Understanding Microcontrollers",
        description: "What is a Microcontroller and how does it work?",
        videoUrl: "https://robo.responcy.net/videos/robotics_5_compressed.mp4",
      ),
    ],
  ),
  Course(
    title: "Flutter Animations",
    subtitle: "Stateful Widgets",
    imagePath: "lib/assets/images/flutter_for_beginners.png",
    description: "Master animations in Flutter with stateful widgets.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Implicit Animations",
        description: "Learn how implicit animations work.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Implicit Animations",
        description: "Quiz on the basics of implicit animations.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Tween & Curves",
        description: "Understanding Tween and Curves in Flutter.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
    ],
  ),
  Course(
    title: "React Native",
    subtitle: "Mobile Cross-Platform",
    imagePath: "lib/assets/images/react_native.png",
    description: "Build cross-platform apps with React Native quickly.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Intro to React Native",
        description: "Basics of React Native development.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: React Native Basics",
        description: "Test your foundational React Native knowledge.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Hooks & State",
        description: "Learn about hooks and state management.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      ),
    ],
  ),
];

/// Four mock courses for "Top Searches".
final List<Course> topSearchCourses = [
  Course(
    title: "Python 101",
    subtitle: "Programming Basics",
    imagePath: "lib/assets/images/python_mock.png",
    description: "Intro to Python programming for all skill levels.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Python Setup",
        description: "Setting up your Python environment.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Python Basics",
        description: "Test your knowledge on Python basics.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Variables & Data Types",
        description: "Understanding variables and data types.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
    ],
  ),
  Course(
    title: "Flutter Widgets",
    subtitle: "UI Components",
    imagePath: "lib/assets/images/flutter_widgets.png",
    description: "Deep dive into common Flutter widgets and usage patterns.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Stateless Widgets",
        description: "Understanding stateless widgets in Flutter.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Stateless vs Stateful",
        description:
            "Quiz on the differences between stateless and stateful widgets.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Stateful Widgets",
        description: "Deep dive into stateful widgets.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      ),
    ],
  ),
  Course(
    title: "AI for Beginners",
    subtitle: "Machine Learning",
    imagePath: "lib/assets/images/ai_mock.png",
    description: "Learn AI basics, neural networks, and data sets.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "What is AI?",
        description: "Introduction to Artificial Intelligence.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: AI Fundamentals",
        description: "Test your understanding of AI basics.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Training Models",
        description: "How to train machine learning models.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      ),
    ],
  ),
  Course(
    title: "Data Structures",
    subtitle: "Comp Science",
    imagePath: "lib/assets/images/data_struct_mock.png",
    description: "Cover essential data structures like lists, trees, & graphs.",
    sections: [
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Arrays & Lists",
        description: "Introduction to arrays and lists.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      ),
      CourseSection(
        type: CourseSectionType.quiz,
        title: "Quiz: Arrays & Lists",
        description: "Test your knowledge on arrays and lists.",
      ),
      CourseSection(
        type: CourseSectionType.lesson,
        title: "Trees & Graphs",
        description: "Learn about trees and graphs in computer science.",
        videoUrl:
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
    ],
  ),
];
