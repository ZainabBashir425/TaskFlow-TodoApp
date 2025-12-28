import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import '../services/supabase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = fetchTasks();
  }

  void refreshData() {
    setState(() {
      _tasksFuture = fetchTasks();
    });
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await SupabaseService.client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Widget _buildHeader(double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFFB26BFF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.yellow.shade600,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Evening!",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "TaskFlow User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            "Today's Progress",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int total, int completed, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: 'Total Task',
              value: total.toString(),
              icon: Icons.access_time,
              // Note: Ensure your StatCard widget also uses Theme.of(context).cardColor internally
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: 'Completed',
              value: completed.toString(),
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasks(List<Map<String, dynamic>> tasks, bool isDark) {
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            "No tasks yet",
            style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Today's Task",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(Icons.repeat, color: Color(0xFF855BE1)),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaskCard(
                title: task['title'] ?? '',
                subtitle: task['description'] ?? '',
                // The TaskCard widget MUST be updated to use Theme.of(context).cardColor
                tags: [
                  TagChip(
                    text: task['category'] ?? '',
                    color: const Color(0xFF8A38F5),
                  ),
                  TagChip(
                    text: task['priority'] ?? '',
                    color: task['priority'] == 'high'
                        ? const Color(0xFFD93C65)
                        : const Color(0xFFEFCB0D),
                  ),
                  TagChip(
                    text: task['due_date'] ?? '',
                    color: isDark ? Colors.white24 : const Color(0xFFE6E9F2),
                    outlined: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Detect Theme Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🔥 Scaffold background now changes with theme
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF6F7FB),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError)
              return const Center(child: Text('Error loading tasks'));

            final tasks = snapshot.data ?? [];
            final total = tasks.length;
            final completed = tasks.where((t) => t['status'] == 'Done').length;
            final progress = total == 0 ? 0.0 : completed / total;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(progress),
                  _buildStatsRow(total, completed, isDark),
                  _buildTodayTasks(tasks, isDark),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
