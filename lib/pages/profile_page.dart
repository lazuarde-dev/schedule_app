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

  // Palette Consistent
  final Color bgColor = const Color(0xFFF8FAFC);
  final Color accentColor = const Color(0xFF4F46E5);
  final Color darkText = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    final data = await StorageService.getUser();
    setState(() {
      user = data;
      isDark = data?.isDarkMode ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator(color: accentColor))
          : Column(
              children: [
                const SizedBox(height: 30),
                _buildProfileHeader(),
                const SizedBox(height: 48),

                // Settings Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel("PREFERENCES"),
                      const SizedBox(height: 12),
                      _buildSettingsGroup([
                        _buildSettingTile(
                          Icons.dark_mode_outlined,
                          "Dark Mode",
                          Switch(
                            value: isDark,
                            activeColor: accentColor,
                            onChanged: (v) async {
                              setState(() => isDark = v);
                              themeNotifier.value = v
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                              user!.isDarkMode = v;
                              await StorageService.saveUser(user!);
                            },
                          ),
                        ),
                        _buildSettingTile(
                          Icons.notifications_none_rounded,
                          "Notifications",
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey[400],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 32),
                      _buildSectionLabel("ACCOUNT"),
                      const SizedBox(height: 12),
                      _buildSettingsGroup([
                        _buildSettingTile(
                          Icons.shield_outlined,
                          "Privacy & Security",
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey[400],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),

                const Spacer(),
                _buildSignOutButton(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 50,
                  color: accentColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: darkText,
                shape: BoxShape.circle,
                border: Border.all(color: bgColor, width: 3),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user!.name,
          style: TextStyle(
            color: darkText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          user!.email,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: darkText.withOpacity(0.4),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, Widget trailing) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: trailing,
    );
  }

  Widget _buildSignOutButton() {
    return TextButton.icon(
      onPressed: () async {
        await StorageService.clearUser();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const LoginPage()),
          (r) => false,
        );
      },
      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
      label: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
