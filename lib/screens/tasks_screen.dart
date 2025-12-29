import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  String _selectedTab = 'All';
  String _searchQuery = "";

  // 1. Remove 'late' and initialize immediately
  // This ensures the field is NEVER uninitialized when build() runs
  final Stream<List<Map<String, dynamic>>> _tasksStream = Supabase
      .instance
      .client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  // --- LOGIC: Toggle Status ---
  Future<void> _toggleStatus(dynamic task) async {
    final newStatus = task['status'] == 'done' ? 'active' : 'done';
    await supabase
        .from('tasks')
        .update({'status': newStatus})
        .eq('id', task['id']);
    // No need to call fetchTasks(), the Stream will update automatically!
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
          : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildSearchBar(isDark),
            const SizedBox(height: 20),
            // We use a StreamBuilder to react to any change in the DB
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _tasksStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState(isDark);
                  }

                  final allTasks = snapshot.data!;

                  // 🔥 Filter tasks for Tabs and Search
                  final filteredTasks = allTasks.where((task) {
                    bool matchesTab = true;
                    if (_selectedTab == 'Active')
                      matchesTab = task['status'] == 'active';
                    if (_selectedTab == 'Done')
                      matchesTab = task['status'] == 'done';

                    bool matchesSearch =
                        task['title'].toString().toLowerCase().contains(
                          _searchQuery,
                        ) ||
                        (task['description']?.toString().toLowerCase().contains(
                              _searchQuery,
                            ) ??
                            false);

                    return matchesTab && matchesSearch;
                  }).toList();

                  return Column(
                    children: [
                      _buildTabs(
                        isDark,
                        allTasks,
                      ), // Pass allTasks to show counts
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                          itemCount: filteredTasks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return _buildTaskItem(context, task);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the TaskCard
  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
      ),
      child: TaskCard(
        title: task['title'] ?? '',
        subtitle: task['description'] ?? '',
        isDone: task['status'] == 'done',
        onStatusToggle: () => _toggleStatus(task),
        onDelete: () => _deleteTask(task['id']),
        tags: [
          TagChip(
            text: task['category'] ?? 'Task',
            color: _getCategoryColor(task['category']),
          ),
          if (task['priority'] != null)
            TagChip(
              text: task['priority'],
              color: _getPriorityColor(task['priority']),
            ),
          if (task['due_date'] != null)
            TagChip(
              text: task['due_date'].toString().split('T')[0],
              color: Colors.grey,
              outlined: true,
            ),
        ],
      ),
    );
  }

  // Updated Tabs to accept the task list for dynamic counts
  Widget _buildTabs(bool isDark, List<dynamic> tasks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildTab('All', tasks.length, isDark),
          const SizedBox(width: 8),
          _buildTab(
            'Active',
            tasks.where((t) => t['status'] == 'active').length,
            isDark,
          ),
          const SizedBox(width: 8),
          _buildTab(
            'Done',
            tasks.where((t) => t['status'] == 'done').length,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count, bool isDark) {
    final bool isActive = _selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF7C63DE)
                : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$label ($count)',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... (Header, SearchBar, PriorityColor Stubs)
  Color _getPriorityColor(p) =>
      p.toString().toLowerCase() == 'high' ? Colors.red : Colors.orange;
  Color _getCategoryColor(c) => const Color(0xFF7C63DE);

  Widget _buildHeader(bool isDark) => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(16),
    child: const Text(
      "My Tasks",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildSearchBar(bool isDark) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search tasks...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _buildEmptyState(bool isDark) =>
      const Center(child: Text("No tasks found"));
}
