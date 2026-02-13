import 'dart:convert';

class Task {
  String name;
  int duration; // dalam menit
  DateTime date;
  String time;

  Task({required this.name, required this.duration, required this.date, required this.time});

  Map<String, dynamic> toMap() => {
    'name': name,
    'duration': duration,
    'date': date.toIso8601String(),
    'time': time,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    name: map['name'],
    duration: map['duration'],
    date: DateTime.parse(map['date']),
    time: map['time'],
  );
}