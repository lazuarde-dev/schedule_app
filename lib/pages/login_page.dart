import 'package:flutter/material.dart';
import 'dart:ui'; // Penting untuk efek Blur
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

  // Skema warna Gen Z (Electric Purple & Soft Pink)
  final Color primaryColor = const Color(0xFF6366f1);
  final Color accentColor = const Color(0xFFec4899);

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("⚠️ Fill it up, bestie!"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Ornaments
          Positioned(
            top: -50,
            right: -50,
            child: _buildCircle(200, primaryColor.withOpacity(0.3)),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: _buildCircle(300, accentColor.withOpacity(0.2)),
          ),

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0f172a),
            ), // Dark Deep Background
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo Section with Glow
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        isRegister
                            ? Icons.auto_awesome
                            : Icons.rocket_launch_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Bold Header
                    Text(
                      isRegister ? "LET'S VIBE" : "WELCOME BACK",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                    Text(
                      "Your digital space, simplified.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    const SizedBox(height: 50),

                    // Glassmorphism Input Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildTextField(
                                nameController,
                                "Your Name",
                                Icons.face_unlock_outlined,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                emailController,
                                "Email Address",
                                Icons.alternate_email_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Modern Gradient Button
                    GestureDetector(
                      onTap: _authAction,
                      child: Container(
                        height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, accentColor],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isRegister ? "CREATE ACCOUNT" : "SIGN IN",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextButton(
                      onPressed: () => setState(() => isRegister = !isRegister),
                      child: RichText(
                        text: TextSpan(
                          text: isRegister ? "Got an account? " : "New here? ",
                          style: TextStyle(color: Colors.grey[400]),
                          children: [
                            TextSpan(
                              text: isRegister ? "Login" : "Join the club",
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
