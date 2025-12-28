import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';
import '../services/supabase_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  late Future<List<Map<String, dynamic>>> _calendarTasksFuture;
  final ScrollController _scrollController = ScrollController();

  // Helper for Dark Mode detection
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _calendarTasksFuture = fetchTasksByDate(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelectedDate(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
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
    _scrollToSelectedDate();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF7B61FF),
                    surface: Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF7B61FF),
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      _refreshCalendarTasks();
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasksByDate(DateTime date) async {
    final dateString = _formatDate(date);
    final response = await SupabaseService.client
        .from('tasks')
        .select()
        .eq('due_date', dateString)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  List<DateTime> getDisplayedDates() {
    DateTime start = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    return List.generate(daysInMonth, (i) => start.add(Duration(days: i)));
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  List<TagChip> _convertDbTags(Map<String, dynamic> task) {
    return [
      TagChip(text: task['category'] ?? 'Task', color: const Color(0xFF8A38F5)),
      TagChip(
        text: task['priority'] ?? 'low',
        color: task['priority'] == 'high'
            ? const Color(0xFFD93C65)
            : const Color(0xFFEFCB0D),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dates = getDisplayedDates();
    final monthName = _monthName(selectedDate.month);

    return Scaffold(
      // 🌙 Background adjusts to Dark/Light mode
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF7B61FF), const Color(0xFFA28BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
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
      height: 110,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: dates.map((d) {
            final isSelected =
                d.day == selectedDate.day && d.month == selectedDate.month;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = d;
                  _refreshCalendarTasks();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 14),
                width: 50,
                height: isSelected ? 110 : 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF7D3CD9), // KEPT AS REQUESTED
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2.0),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7B61FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    Text(
                      _weekdayName(d.weekday),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d.day.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSelected ? 26 : 22,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "$monthName ${selectedDate.day}, ${selectedDate.year}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${tasks.length} Tasks",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C63DE),
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
                          return TaskCard(
                            title: task["title"] ?? "No Title",
                            subtitle: task["description"] ?? "No Description",
                            tags: _convertDbTags(task),
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
            Icons.task_outlined,
            size: 64,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            "No tasks for this date",
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
          ),
        ],
      ),
    );
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
