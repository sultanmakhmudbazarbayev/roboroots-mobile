import 'package:flutter/material.dart';
import 'package:roboroots/api/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roboroots/screens/auth/sign_in_screen.dart';
import 'package:roboroots/screens/home/home_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedRole = 'student';
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  final List<String> _roles = ['student', 'teacher'];

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final role = _selectedRole;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please agree to the Terms & Conditions')),
      );
      return;
    }

    try {
      final success = await AuthService().register(
        email: email,
        fullName: fullName,
        password: password,
        role: role,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          children: [
            Image.asset('lib/assets/images/robot_logo.png', height: 150),
            SizedBox(height: 30),
            Text("Create Your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),

            _buildTextField(_emailController, "Email", Icons.email_outlined),
            SizedBox(height: 16),
            _buildTextField(
                _fullNameController, "Full Name", Icons.person_outline),
            SizedBox(height: 16),

            // Role dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles
                    .map((role) => DropdownMenuItem(
                        value: role, child: Text(role.capitalize())))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
                decoration: InputDecoration(
                  labelText: "Role",
                  border: InputBorder.none,
                  icon: Icon(Icons.school),
                ),
              ),
            ),
            SizedBox(height: 16),

            _buildTextField(_passwordController, "Password", Icons.lock_outline,
                obscure: true),
            SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, "Confirm Password",
                Icons.lock_outline,
                obscure: true),
            SizedBox(height: 16),

            // Terms checkbox
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) =>
                      setState(() => _agreeToTerms = value ?? false),
                  activeColor: Colors.green,
                ),
                Expanded(
                    child: Text("Agree to Terms & Conditions",
                        style: TextStyle(fontSize: 16))),
              ],
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _signUp,
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              label: Text("Sign Up",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an Account? "),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignInPage())),
                  child: Text("SIGN IN",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure && _obscurePassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          suffixIcon: obscure
              ? IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// Extension to capitalize role text
extension StringCasingExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
