import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import '../services/supabase_service.dart';
import 'new_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, dynamic>>>? _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = fetchTasks();
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await SupabaseService.client
        .from('tasks')
        .select()
        .order('due_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Widget _buildHeader(double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFFB26BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
              minHeight: 10,
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int total, int completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
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

  Widget _buildTodayTasks(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text("No tasks yet")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "Today's Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.repeat, color: Color(0xFF855BE1)),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaskCard(
                title: task['title'] ?? '',
                subtitle: task['description'] ?? '',
                tags: [
                  TagChip(
                    text: task['category'] ?? '',
                    color: const Color(0xFF8A38F5),
                  ),
                  TagChip(
                    text: task['priority'] ?? '',
                    color: const Color(0xFFD93C65),
                  ),
                  TagChip(
                    text: task['due_date'] ?? '',
                    color: const Color(0xFFE6E9F2),
                    outlined: true,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewTaskScreen()),
    );

    if (result == true) {
      setState(() {
        _tasksFuture = fetchTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        backgroundColor: const Color(0xFF7B61FF),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Something went wrong'));
            }

            final tasks = snapshot.data!;
            final totalTasks = tasks.length;
            final completedTasks = tasks
                .where((t) => t['status'] == 'Done')
                .length;

            final progress = totalTasks == 0
                ? 0.0
                : completedTasks / totalTasks;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(progress),
                  _buildStatsRow(totalTasks, completedTasks),
                  _buildTodayTasks(tasks),
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
