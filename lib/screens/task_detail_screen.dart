import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final dynamic task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: task['status'] == 'done'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task['status'].toString().toUpperCase(),
                    style: TextStyle(
                      color: task['status'] == 'done'
                          ? Colors.green
                          : Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  task['due_date']?.toString().split('T')[0] ?? "No Date",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              task['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              task['description'] ?? 'No description provided.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const Divider(height: 40),
            // Show Tags
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(task['category'] ?? 'General')),
                Chip(label: Text("Priority: ${task['priority'] ?? 'None'}")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
