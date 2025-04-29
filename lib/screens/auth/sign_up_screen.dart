import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roboroots/screens/auth/sign_in_screen.dart';
import 'package:roboroots/screens/home/home_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  /// Makes a POST request to register the user
  Future<void> _signUp() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    // Endpoint URL for registration
    final url = Uri.parse('https://robo.responcy.net/auth/register');

    try {
      // Send the POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        print('Received token: $token');

        // Save the token using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        // Optionally, navigate to your HomePage or another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle non-200 responses
        print('Registration failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally set a background color if desired
      // backgroundColor: Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            // Logo & Branding
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/images/robot_logo.png', // Replace with your logo asset path
                    height: 150,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Heading Text
            Text(
              "Getting Started!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Create an Account to Continue Your Courses",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Email TextField
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // Optionally add a box shadow for a card-like effect
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Password TextField
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Terms & Conditions
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                Text(
                  "Agree to Terms & Conditions",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _signUp, // Call _signUp when button pressed.
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                label: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Customize to your brand color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Or Continue With
            Text(
              "Or Continue With",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 16),

            // Social Buttons (Google, Apple)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialIconButton(
                  iconPath:
                      'lib/assets/icons/google_icon.png', // Replace with your Google icon
                  onTap: () {
                    // Handle Google signup
                  },
                ),
                SizedBox(width: 20),
                _SocialIconButton(
                  iconPath:
                      'lib/assets/icons/apple_icon.png', // Replace with your Apple icon
                  onTap: () {
                    // Handle Apple signup
                  },
                ),
              ],
            ),
            SizedBox(height: 30),

            // Already have an Account? SIGN IN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account? ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Customize color to match brand
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// A small widget for social icons (Google / Apple)
class _SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          // Optionally add box shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
