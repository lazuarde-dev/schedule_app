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
    if (widget.index != null) tasks[widget.index!] = newTask;
    else tasks.add(newTask);

    await StorageService.saveTasks(tasks);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(widget.index != null ? "Edit Task" : "New Task", style: const TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInput(nameController, "What needs to be done?", Icons.edit_note_rounded),
            const SizedBox(height: 20),
            _buildInput(durationController, "Duration (minutes)", Icons.timer_outlined, type: TextInputType.number),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: selectedTime);
                if (picked != null) setState(() => selectedTime = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time_filled_rounded, color: color),
                    const SizedBox(width: 15),
                    Text("Start at: ${selectedTime.format(context)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(widget.index != null ? "Save Changes" : "Create Task", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}