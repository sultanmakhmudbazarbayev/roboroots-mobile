import 'package:flutter/material.dart';
import 'package:roboroots/screens/auth/sign_in_screen.dart';
import 'package:roboroots/screens/auth/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and branding
              Image.asset(
                'lib/assets/images/robot_logo.png', // Update with your logo path
                height: 150,
              ),
              SizedBox(height: 40),
              // Heading
              Text(
                "Let’s you in",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),

              // Continue with Google
              _SocialLoginButton(
                iconPath: 'lib/assets/icons/google_icon.png',
                text: "Continue with Google",
                onTap: () {
                  // Handle Google login
                },
              ),
              SizedBox(height: 16),

              // Continue with Apple
              _SocialLoginButton(
                iconPath: 'lib/assets/icons/apple_icon.png',
                text: "Continue with Apple",
                onTap: () {
                  // Handle Apple login
                },
              ),

              SizedBox(height: 16),
              // Divider or ( Or ) text
              Text(
                "( Or )",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),

              // Sign in with your account
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to SignUpPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    "Sign In with Your Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sign Up prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an Account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to SignUpPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A reusable widget for social login buttons:
class _SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Add a light shadow if desired
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              iconPath,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
