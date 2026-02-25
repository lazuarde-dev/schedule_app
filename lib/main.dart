import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/storage_service.dart';
import 'models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Global Notifier untuk perubahan tema secara real-time
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memuat preferensi user (termasuk dark mode) sebelum aplikasi dirender
  final user = await StorageService.getUser();
  if (user != null && user.isDarkMode) {
    themeNotifier.value = ThemeMode.dark;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Schedule AI',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,

          // TEMA TERANG: Modern Slate & Indigo
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4F46E5), // Indigo Primary
              brightness: Brightness.light,
              surface: const Color(0xFFF8FAFC), // Slate 50
              onSurface: const Color(0xFF1E293B), // Slate 900
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            // Menggunakan font sistem yang bersih (Inter-like)
            fontFamily: 'Inter',
          ),

          // TEMA GELAP: Deep Navy & Soft Indigo
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(
                0xFF818CF8,
              ), // Lighter Indigo for Dark Mode
              brightness: Brightness.dark,
              surface: const Color(0xFF0F172A), // Deep Navy Slate
              onSurface: const Color(0xFFF1F5F9), // Slate 100
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),

          home: FutureBuilder<User?>(
            future: StorageService.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              // Jika data user ada, langsung ke HomePage, jika tidak ke LoginPage
              return (snapshot.hasData && snapshot.data != null)
                  ? const HomePage()
                  : const LoginPage();
            },
          ),
        );
      },
    );
  }
}
