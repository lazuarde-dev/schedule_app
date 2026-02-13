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

  _authAction() async {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      final user = User(name: nameController.text, email: emailController.text);
      await StorageService.saveUser(user);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Harap isi semua field")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.05), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(isRegister ? Icons.auto_awesome : Icons.fingerprint, size: 80, color: color),
                ),
                const SizedBox(height: 30),
                Text(
                  isRegister ? "Join Us" : "Welcome Back",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color, letterSpacing: -1),
                ),
                Text("Organize your life with elegance", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 50),
                _buildTextField(nameController, "Full Name", Icons.person_outline),
                const SizedBox(height: 20),
                _buildTextField(emailController, "Email Address", Icons.email_outlined),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _authAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 5,
                    shadowColor: color.withOpacity(0.4),
                  ),
                  child: Text(isRegister ? "Create Account" : "Sign In", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => setState(() => isRegister = !isRegister),
                  child: Text(
                    isRegister ? "Already have an account? Login" : "Don't have an account? Register",
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
    );
  }
}