import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/storage_service.dart';
import 'models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          title: 'Schedule Generator',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // TEMA TERANG (Elegant Cocoa)
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6F4E37),
              primary: const Color(0xFF6F4E37),
              secondary: const Color(0xFFA67B5B),
              surface: const Color(0xFFFFF9F5),
              background: const Color(0xFFFFF9F5),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFFFF9F5),
            fontFamily: 'sans-serif',
          ),
          // TEMA GELAP (Dark Chocolate)
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3C2A21),
              primary: const Color(0xFFD4A373),
              secondary: const Color(0xFFBC8A5F),
              surface: const Color(0xFF1A120B),
              background: const Color(0xFF1A120B),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1A120B),
            fontFamily: 'sans-serif',
          ),
          home: FutureBuilder<User?>(
            future: StorageService.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
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
