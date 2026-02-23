import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  final int? index;
  const AddTaskPage({super.key, this.task, this.index});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Color Palette Consistent
  final Color bgColor = const Color(0xFFF8FAFC);
  final Color accentColor = const Color(0xFF4F46E5);
  final Color darkText = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      nameController.text = widget.task!.name;
      durationController.text = widget.task!.duration.toString();
    }
  }

  _save() async {
    if (nameController.text.isEmpty || durationController.text.isEmpty) return;
    final duration = int.tryParse(durationController.text);
    if (duration == null) return;

    final newTask = Task(
      name: nameController.text,
      duration: duration,
      date: DateTime.now(),
      time: selectedTime.format(context),
    );

    final tasks = await StorageService.getTasks();
    if (widget.index != null) {
      tasks[widget.index!] = newTask;
    } else {
      tasks.add(newTask);
    }

    await StorageService.saveTasks(tasks);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.index != null ? "Edit Activity" : "New Activity",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            _buildSectionLabel("TASK NAME"),
            _buildInput(
              nameController,
              "e.g. Flutter Coding Session",
              Icons.edit_rounded,
            ),
            const SizedBox(height: 32),
            _buildSectionLabel("DURATION (MINUTES)"),
            _buildInput(
              durationController,
              "e.g. 45",
              Icons.timer_outlined,
              type: TextInputType.number,
            ),
            const SizedBox(height: 32),
            _buildSectionLabel("START TIME"),
            _buildTimeTile(),
            const Spacer(),
            _buildSaveButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          color: darkText.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: accentColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTile() {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: accentColor,
                  onPrimary: Colors.white,
                  onSurface: darkText,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => selectedTime = picked);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.alarm_rounded, color: accentColor, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              selectedTime.format(context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),
            const Spacer(),
            Icon(Icons.expand_more_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: darkText,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        widget.index != null ? "Update Schedule" : "Add to Schedule",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
