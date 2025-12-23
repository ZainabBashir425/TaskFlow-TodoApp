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
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Row(
              children: const [
                Text(
                  'All Task',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.menu_open_sharp),
              ],
            ),
          ),

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search task...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(vertical: 12),

                // NORMAL BORDER
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.4),
                ),

                // ENABLED BORDER
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.4),
                ),

                // FOCUSED BORDER
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade600, width: 1.4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔖 TABS BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // ACTIVE TAB (GRADIENT)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C63DE), Color(0xFFB571E0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'All (2)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ACTIVE TAB
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300, // grey border
                        width: 1.6,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Active (2)',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // DONE TAB
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300, // grey border
                        width: 1.6,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Done (2)',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // TASK LIST
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  TaskCard(
                    title: "Welcome to TaskFlow!",
                    subtitle: "Complete this task to get started",
                    tags: [
                      TagChip(text: 'Getting Started', color: Color(0xFF8A38F5)),
                      TagChip(text: 'high', color: Color(0xFFD93C65)),
                      TagChip(
                        text: 'Oct 18',
                        color: Color(0xFFE6E9F2),
                        outlined: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TaskCard(
                    title: "Create Your first task",
                    subtitle: "Tap the + button to add a new task",
                    tags: [
                      TagChip(text: 'Tutorial', color: Color(0xFF50B27A)),
                      TagChip(text: 'medium', color: Color(0xFFEFCB0D)),
                      TagChip(
                        text: 'Oct 18',
                        color: Color(0xFFE6E9F2),
                        outlined: true,
                      ),
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
