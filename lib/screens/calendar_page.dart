import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import 'task_detail_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  DateTime selectedDate = DateTime.now();
  late Future<List<Map<String, dynamic>>> _calendarTasksFuture;
  final ScrollController _scrollController = ScrollController();

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _calendarTasksFuture = fetchTasksByDate(selectedDate);
    // Use a small delay to ensure the list is rendered before scrolling
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scrollToSelectedDate(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
      // Offset calculation: (day - 1) * (width + margin)
      double offset = (selectedDate.day - 1) * 64.0;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _refreshCalendarTasks() {
    setState(() {
      _calendarTasksFuture = fetchTasksByDate(selectedDate);
    });
  }

  // --- LOGIC: Toggle Status ---
  Future<void> _toggleStatus(Map<String, dynamic> task) async {
    final newStatus = task['status'] == 'done' ? 'active' : 'done';
    await supabase
        .from('tasks')
        .update({'status': newStatus})
        .eq('id', task['id']);
    _refreshCalendarTasks();
  }

  // --- LOGIC: Delete Task ---
  Future<void> _deleteTask(dynamic id) async {
    await supabase.from('tasks').delete().eq('id', id);
    _refreshCalendarTasks();
  }

  Future<List<Map<String, dynamic>>> fetchTasksByDate(DateTime date) async {
    final dateString = _formatDate(date);
    final response = await supabase
        .from('tasks')
        .select()
        .eq('due_date', dateString)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final dates = _getDisplayedDates();
    final monthName = _monthName(selectedDate.month);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildMonthHeader(monthName),
          const SizedBox(height: 16),
          _buildDateSlider(dates),
          const SizedBox(height: 12),
          _buildTaskList(monthName),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFFA28BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calendar",
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Text(
            "View Your Tasks by Date",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(String monthName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            "$monthName ${selectedDate.year}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 22,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSlider(List<DateTime> dates) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final d = dates[index];
          final isSelected =
              d.day == selectedDate.day &&
              d.month == selectedDate.month &&
              d.year == selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() => selectedDate = d);
              _refreshCalendarTasks();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 14),
              width: 50,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF7B61FF), Color(0xFFB26BFF)],
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? Colors.white12 : Colors.grey.shade300),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayName(d.weekday),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d.day.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(String monthName) {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _calendarTasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data ?? [];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    Text(
                      "${tasks.length} Tasks for Today",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemCount: tasks.length,
                        itemBuilder: (_, i) {
                          final task = tasks[i];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: task),
                              ),
                            ),
                            child: TaskCard(
                              title: task["title"] ?? "Untitled",
                              subtitle: task["description"] ?? "",
                              isDone: task['status'] == 'done',
                              onStatusToggle: () => _toggleStatus(task),
                              onDelete: () => _deleteTask(task['id']),
                              tags: [
                                TagChip(
                                  text: task['category'] ?? 'Task',
                                  color: const Color(0xFF8A38F5),
                                ),
                                TagChip(
                                  text: task['priority'] ?? 'low',
                                  color: task['priority'] == 'high'
                                      ? const Color(0xFFD93C65)
                                      : const Color(0xFFEFCB0D),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: isDark ? Colors.white10 : Colors.grey[200],
          ),
          const SizedBox(height: 16),
          Text(
            "No tasks scheduled",
            style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Date Helpers ---
  List<DateTime> _getDisplayedDates() {
    DateTime start = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    return List.generate(daysInMonth, (i) => start.add(Duration(days: i)));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      _refreshCalendarTasks();
      _scrollToSelectedDate();
    }
  }

  String _monthName(int m) => [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ][m - 1];
  String _weekdayName(int w) =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][w - 1];
}
