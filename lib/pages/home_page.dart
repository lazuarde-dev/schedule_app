import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import 'add_task_page.dart';
import 'result_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String userName = "Mahesa"; // Default ke nama panggilanmu

  final Color bgColor = const Color(0xFFF8FAFC);
  final Color accentColor = const Color(0xFF4F46E5); // Indigo Professional
  final Color darkText = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final t = await StorageService.getTasks();
    final u = await StorageService.getUser();
    setState(() {
      tasks = t;
      if (u != null) userName = u.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Hi, $userName 👋",
              style: TextStyle(color: darkText, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1),
            ),
            Text(
              "Let's focus on your goals today.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildActionCard(),
            const SizedBox(height: 40),
            _buildSectionHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty ? _buildEmptyState() : _buildTaskList(),
            ),
            const SizedBox(height: 16),
            _buildGenerateButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text("Planner", 
        style: TextStyle(color: darkText, fontWeight: FontWeight.w900, fontSize: 22)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilePage())).then((_) => _loadData()),
            icon: CircleAvatar(
              backgroundColor: accentColor.withOpacity(0.1),
              child: Icon(Icons.person_outline_rounded, color: accentColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: darkText, // Dark Card untuk variasi Gen Z Professional
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: darkText.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Add Task", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Sync your workflow with AI refinement.", 
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AddTaskPage())).then((_) => _loadData()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: darkText,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 0,
            ),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Active Schedule", 
          style: TextStyle(color: darkText, fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text("${tasks.length} tasks", 
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                height: 44, width: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Icon(Icons.calendar_today_outlined, size: 18, color: accentColor)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tasks[index].name, style: TextStyle(color: darkText, fontWeight: FontWeight.w700, fontSize: 15)),
                    Text("${tasks[index].duration}m • ${tasks[index].time}", 
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                onPressed: () {
                  setState(() => tasks.removeAt(index));
                  StorageService.saveTasks(tasks);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers_clear_outlined, size: 64),
            const SizedBox(height: 16),
            Text("Your list is empty, Mahesa.", 
              style: TextStyle(color: darkText, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ResultPage())),
      icon: const Icon(Icons.auto_awesome_rounded, size: 20),
      label: const Text("Refine with Gemini", style: TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}