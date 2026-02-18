import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isRegister = false;

  // Palet Warna Minimalist & Professional 2026
  final Color bgColor = const Color(0xFFF8FAFC); // Off-white clean
  final Color cardColor = Colors.white;
  final Color primaryText = const Color(0xFF1E293B); // Slate 900
  final Color secondaryText = const Color(0xFF64748B); // Slate 500
  final Color accentColor = const Color(0xFF4F46E5); // Indigo Professional

  _authAction() async {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      final user = User(name: nameController.text, email: emailController.text);
      await StorageService.saveUser(user);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _showCustomSnackBar("Please fill all fields, Mahesa!");
    }
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryText,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              // Brand Identity (Simple & Bold)
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.blur_on_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isRegister ? "Create Account" : "Welcome Back",
                style: TextStyle(
                  color: primaryText,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sign in to continue your journey.",
                style: TextStyle(color: secondaryText, fontSize: 16),
              ),
              const SizedBox(height: 48),

              // Form Section
              _buildInputLabel("FULL NAME"),
              _buildTextField(
                nameController,
                "Swasti Mahesa",
                Icons.person_outline,
              ),
              const SizedBox(height: 24),
              _buildInputLabel("EMAIL ADDRESS"),
              _buildTextField(
                emailController,
                "mahesa@example.com",
                Icons.mail_outline,
              ),

              const SizedBox(height: 40),

              // Professional Primary Button
              ElevatedButton(
                onPressed: _authAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isRegister ? "Get Started" : "Sign In",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Secondary Toggle Action
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isRegister = !isRegister),
                  child: RichText(
                    text: TextSpan(
                      text: isRegister
                          ? "Already have an account? "
                          : "New to the platform? ",
                      style: TextStyle(color: secondaryText, fontSize: 14),
                      children: [
                        TextSpan(
                          text: isRegister ? "Login" : "Join Now",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: primaryText),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: secondaryText, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
