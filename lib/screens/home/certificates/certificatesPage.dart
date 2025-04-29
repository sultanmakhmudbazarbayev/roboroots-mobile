import 'package:flutter/material.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  // Dummy certificate data.
  // Certificates from our platform.
  final List<Map<String, dynamic>> platformCertificates = const [
    {
      'title': 'Flutter Development',
      'course': 'Flutter for Beginners',
      'organization': 'Other Platforms',
      'givenDate': '2023-02-15',
      'expiryDate': '2025-02-15',
      'image': 'lib/assets/images/flutter_beginner_cert.png',
    },
    {
      'title': 'Advanced Flutter',
      'course': 'Advanced Flutter',
      'organization': 'Our Platform',
      'givenDate': '2023-06-01',
      'expiryDate': '2025-06-01',
      'image': 'lib/assets/images/flutter_advanced_cert.png',
    },
  ];

  // Certificates from other places.
  final List<Map<String, dynamic>> externalCertificates = const [
    {
      'title': 'React Native Development',
      'course': 'React Native Bootcamp',
      'organization': 'Udemy',
      'givenDate': '2022-11-20',
      'expiryDate': '2024-11-20',
      'image': 'lib/assets/images/react_native_cert.png',
    },
    {
      'title': 'Python for Data Science',
      'course': 'Python Data Science Course',
      'organization': 'Coursera',
      'givenDate': '2022-09-10',
      'expiryDate': '2024-09-10',
      'image': 'lib/assets/images/python_data_cert.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Certificates",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Certificates from our Platform",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...platformCertificates
              .map((cert) => CertificateCard(certificate: cert))
              .toList(),
          const SizedBox(height: 40),
          const Text(
            "Certificates from Other Places",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...externalCertificates
              .map((cert) => CertificateCard(certificate: cert))
              .toList(),
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final Map<String, dynamic> certificate;
  const CertificateCard({Key? key, required this.certificate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certificate image with rounded top corners.
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              certificate['image'],
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certificate title.
                Text(
                  certificate['title'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Course information.
                Text(
                  "Course: ${certificate['course']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                // Organization.
                Text(
                  "Organization: ${certificate['organization']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                // Given date.
                Text(
                  "Given on: ${certificate['givenDate']}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                // Expiry date.
                Text(
                  "Expires on: ${certificate['expiryDate']}",
                  style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
