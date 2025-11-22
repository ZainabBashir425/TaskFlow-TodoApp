import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              children: const [
                Text('All Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.filter_list),
              ],
            ),
          ),
          // search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search task...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF9D79FF), Color(0xFF7B61FF)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('All (2)', style: TextStyle(color: Colors.white))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Active (2)')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Done (2)')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // list of tasks
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  TaskCard(
                    title: "Welcome to TaskFlow!",
                    subtitle: "Complete this task to get started",
                    tags: [
                      TagChip(text: 'Getting Started', color: Color(0xFFCFB9FF)),
                      TagChip(text: 'high', color: Color(0xFFFFD0DA)),
                      TagChip(text: 'Oct 18', color: Color(0xFFE6E9F2), outlined: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TaskCard(
                    title: "Create Your first task",
                    subtitle: "Tap the + button to add a new task",
                    tags: [
                      TagChip(text: 'Tutorial', color: Color(0xFFDFF8EA)),
                      TagChip(text: 'medium', color: Color(0xFFFFF1C9)),
                      TagChip(text: 'Oct 18', color: Color(0xFFE6E9F2), outlined: true),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
