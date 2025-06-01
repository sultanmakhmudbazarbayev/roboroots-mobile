// lib/screens/home/certificates_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:roboroots/api/certificate_service.dart';
import 'package:roboroots/api/api_service.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  late Future<List<Map<String, dynamic>>> _futureCerts;

  @override
  void initState() {
    super.initState();
    _futureCerts = CertificateService().getUserCertificates();
  }

  Future<void> _openCertificate(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open certificate.')),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Certificates', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4B6FFF),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureCerts,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final certs = snap.data!;
          if (certs.isEmpty) {
            return const Center(child: Text('No certificates yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: certs.length,
            itemBuilder: (context, i) {
              final c = certs[i];
              final course = c['Course'] as Map<String, dynamic>?;
              final issuedAt = c['info']?['issued_at'] ?? '';
              final rawLink = c['url_link'] as String? ?? '';
              final fullUrl = ApiService.baseUrl! + rawLink;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c['info']?['course_name'] ?? course?['name'] ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Issued: $issuedAt'),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () => _openCertificate(fullUrl),
                        child: const Text('View Certificate'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
