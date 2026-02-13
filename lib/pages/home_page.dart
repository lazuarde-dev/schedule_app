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
  String userName = "User";

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Schedule", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 24)),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilePage())).then((_) => _loadData()),
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.person_rounded, color: colorScheme.primary),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text("Hi, $userName 👋", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            Text("Let's make today productive.", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 30),
            _buildActionCard(colorScheme),
            const SizedBox(height: 35),
            Row(
              children: [
                const Text("Today's Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text("${tasks.length} items", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty ? _buildEmptyState() : _buildTaskList(colorScheme),
            ),
            const SizedBox(height: 15),
            _buildGenerateButton(colorScheme),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(ColorScheme color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.primary, color.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: color.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("New Activity", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Add your task and let AI refine your schedule.", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AddTaskPage())).then((_) => _loadData()),
              borderRadius: BorderRadius.circular(20),
              child: Padding(padding: const EdgeInsets.all(12), child: Icon(Icons.add, color: color.primary, size: 28)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskList(ColorScheme color) {
    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(bottom: 20),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                height: 50, width: 50,
                decoration: BoxDecoration(color: color.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text("${index + 1}", style: TextStyle(color: color.primary, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tasks[index].name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("${tasks[index].duration} mins • ${tasks[index].time}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee_outlined, size: 100, color: Colors.grey.withAlpha(50)),
          const SizedBox(height: 16),
          Text("No plans yet. Take a sip of coffee!", style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(ColorScheme color) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: color.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ResultPage())),
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text("Refine with Gemini AI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }
}