import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _tasksKey = 'user_tasks';
  static const String _summaryKey = 'last_summary';
  static const String _userKey = 'user_session';

  // --- USER / AUTH SECTION ---
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(user.toMap());
    await prefs.setString(_userKey, encoded);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_userKey);
    if (data == null) return null;
    return User.fromMap(jsonDecode(data));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // --- TASK SECTION ---
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_tasksKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((t) => Task.fromMap(t)).toList();
  }

  // --- SUMMARY SECTION ---
  static Future<void> saveSummary(String summary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_summaryKey, summary);
  }

  static Future<String?> getSummary() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_summaryKey);
  }
}