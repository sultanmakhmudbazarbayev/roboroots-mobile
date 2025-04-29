import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roboroots/screens/auth/sign_up_screen.dart';
import 'package:roboroots/screens/home/home_screen.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Function to perform login: makes the POST request, saves the token, and navigates to HomePage.
  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final url = Uri.parse('https://robo.responcy.net/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        print('Received token: $token');

        // Save the token using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        // Navigate to HomePage
        _navigateToHomePage();
      } else {
        // If the server returns an error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      print('Error during sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Navigate to the Home Page.
  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(), // Replace with your HomePage widget
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            // Logo & Branding
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/images/robot_logo.png', // Replace with your logo
                    height: 150,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Heading Text
            Text(
              "Let’s Sign In!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Login to Your Account to Continue Your Courses",
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

            // Remember Me & Forgot Password Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    Text(
                      "Remember Me",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle forgot password flow
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _signIn, // Use the sign-in function
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                label: Text(
                  "Sign In",
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
                  iconPath: 'lib/assets/icons/google_icon.png',
                  onTap: () {
                    // Handle Google sign-in
                  },
                ),
                SizedBox(width: 20),
                _SocialIconButton(
                  iconPath: 'lib/assets/icons/apple_icon.png',
                  onTap: () {
                    // Handle Apple sign-in
                  },
                ),
              ],
            ),
            SizedBox(height: 30),

            // Don't have an Account? SIGN UP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an Account? ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
