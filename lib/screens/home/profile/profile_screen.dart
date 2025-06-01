import 'package:flutter/material.dart';
import 'package:roboroots/api/api_service.dart';
import 'package:roboroots/api/user_service.dart';

// Extension to capitalize first letter
extension StringCasingExtension on String {
  String capitalize() =>
      isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userService = UserService();
      final data = await userService.getUserInfo();
      setState(() {
        _userData = data['userData'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    final String name = _userData?['full_name'] ?? '';
    // force it to be a String so the extension applies
    final String roleRaw = (_userData?['role'] ?? '').toString();
    final String role = roleRaw.capitalize();

    final String level = (_userData?['level']?.toString() ?? '');
    final String followers = (_userData?['followers_count']?.toString() ?? '0');
    final String followings =
        (_userData?['followings_count']?.toString() ?? '0');
    final String balance =
        (_userData?['balance'] as num?)?.toStringAsFixed(2) ?? '0.00';
    final certificates =
        _userData?['certificates_earned_count']?.toString() ?? '0';
    final projects = _userData?['projects_completed_count']?.toString() ?? '0';
    final streak = "${_userData?['strike_days_count'] ?? 0} Days";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade100,
              image: _userData?['image'] != null
                  ? DecorationImage(
                      image: NetworkImage(
                          '${ApiService.baseUrl}${_userData!['image']}'),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _userData?['image'] == null
                ? Center(
                    child: Icon(Icons.person,
                        size: 60, color: Colors.blue.shade700))
                : null,
          ),
          const SizedBox(height: 16),
          Text(name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 4),
          Text(
            "LEVEL $level\n${role.capitalize()}",
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Followers, Following & Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard("Followers", followers),
              const SizedBox(width: 16),
              _buildStatCard("Following", followings),
              const SizedBox(width: 16),
              _buildStatCard("Balance", "\$$balance"),
            ],
          ),

          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Achievements",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildAchievementBlock(Icons.card_membership,
                      "Certificates\nEarned", certificates)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildAchievementBlock(Icons.build_circle_outlined,
                      "Projects\nCompleted", projects)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildAchievementBlock(
                      Icons.whatshot, "Current\nStreak", streak)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildAchievementBlock(
                      Icons.stars, "Mastery\nLevel", level)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(24)),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAchievementBlock(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 6,
              offset: const Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black87, height: 1.2)),
        ],
      ),
    );
  }
}
