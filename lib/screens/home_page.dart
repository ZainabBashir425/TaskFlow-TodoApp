import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import 'task_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;

  // 1. Define the Realtime Stream
  // This listens to the 'tasks' table and pushes updates automatically
  final Stream<List<Map<String, dynamic>>> _tasksStream = Supabase
      .instance
      .client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  // --- LOGIC: Toggle Status ---
  // Notice we removed 'refreshData()' because the Stream handles it!
  Future<void> _toggleStatus(Map<String, dynamic> task) async {
    final newStatus = task['status'] == 'done' ? 'active' : 'done';
    await supabase
        .from('tasks')
        .update({'status': newStatus})
        .eq('id', task['id']);
  }

  // --- LOGIC: Delete Task ---
  Future<void> _deleteTask(dynamic id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF6F7FB),
      body: SafeArea(
        // 2. Use StreamBuilder instead of FutureBuilder
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _tasksStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF7B61FF)),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading tasks'));
            }

            // 3. Extract the real-time data
            final tasks = snapshot.data ?? [];
            final total = tasks.length;
            final completed = tasks.where((t) => t['status'] == 'done').length;
            final progress = total == 0 ? 0.0 : completed / total;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(progress),
                  _buildStatsRow(total, completed, isDark),
                  _buildTodayTasks(tasks, isDark),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
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
          const SizedBox(height: 25),
          const Text(
            "Today's Progress",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toInt()}% Completed",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
      return _buildEmptyState(isDark);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Tasks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(Icons.repeat, color: Color(0xFF855BE1), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          // We take the top 5 from the live stream
          ...tasks.take(5).map((task) => _buildTaskItem(task, isDark)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
        ),
        child: TaskCard(
          title: task['title'] ?? 'Untitled',
          subtitle: task['description'] ?? '',
          isDone: task['status'] == 'done',
          onStatusToggle: () => _toggleStatus(task),
          onDelete: () => _deleteTask(task['id']),
          tags: [
            TagChip(
              text: task['category'] ?? 'General',
              color: const Color(0xFF8A38F5),
            ),
            if (task['priority'] != null)
              TagChip(
                text: task['priority'].toString(),
                color: task['priority'].toString().toLowerCase() == 'high'
                    ? const Color(0xFFD93C65)
                    : const Color(0xFFEFCB0D),
              ),
            if (task['due_date'] != null)
              TagChip(
                text: task['due_date'].toString().split('T')[0],
                color: isDark ? Colors.white38 : Colors.grey.shade600,
                outlined: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.task_outlined,
              size: 50,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              "No tasks for today",
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
