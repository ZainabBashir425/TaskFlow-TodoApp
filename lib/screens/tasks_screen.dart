import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Detect Theme Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Row(
              children: [
                Text(
                  'All Task',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    // 2. Adjust Header Text Color
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.menu_open_sharp,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search task...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),

                filled: true,
                // 3. Dynamic search bar background
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,

                contentPadding: const EdgeInsets.symmetric(vertical: 12),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade400,
                    width: 1.4,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade400,
                    width: 1.4,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF7C63DE),
                    width: 1.4,
                  ),
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
                // ACTIVE TAB (Keep Gradient as is, it looks great in both modes)
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
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // INACTIVE TAB (Dynamic background and border)
                _buildInactiveTab('Active (2)', isDark),
                const SizedBox(width: 8),
                _buildInactiveTab('Done (2)', isDark),
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
                  const TaskCard(
                    title: "Welcome to TaskFlow!",
                    subtitle: "Complete this task to get started",
                    tags: [
                      TagChip(
                        text: 'Getting Started',
                        color: Color(0xFF8A38F5),
                      ),
                      TagChip(text: 'high', color: Color(0xFFD93C65)),
                      TagChip(
                        text: 'Oct 18',
                        color: Color(0xFFE6E9F2),
                        outlined: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const TaskCard(
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

  // Helper method to keep code clean
  Widget _buildInactiveTab(String label, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          // 4. Flip tab background and border
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
            width: 1.6,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
