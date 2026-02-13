import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../main.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    final data = await StorageService.getUser();
    setState(() { user = data; isDark = data?.isDarkMode ?? false; });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold))),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(radius: 65, backgroundColor: color.withOpacity(0.1), child: Icon(Icons.person_rounded, size: 70, color: color)),
                      Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)), child: const Icon(Icons.camera_alt, color: Colors.white, size: 20))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(user!.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                Text(user!.email, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                const SizedBox(height: 40),
                _buildSettingTile(Icons.dark_mode_rounded, "Dark Mode", Switch(
                  value: isDark, 
                  onChanged: (v) async {
                    setState(() => isDark = v);
                    themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                    user!.isDarkMode = v;
                    await StorageService.saveUser(user!);
                  }
                )),
                _buildSettingTile(Icons.notifications_active_outlined, "Notifications", const Icon(Icons.arrow_forward_ios_rounded, size: 16)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButton.icon(
                    onPressed: () async {
                      await StorageService.clearUser();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const LoginPage()), (r) => false);
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    label: const Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, Widget trailing) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: trailing,
      ),
    );
  }
}