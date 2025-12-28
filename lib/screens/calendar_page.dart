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

  // Controller to handle the horizontal slider movement
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize data for today
    _calendarTasksFuture = fetchTasksByDate(selectedDate);

    // Auto-scroll to today's date once the UI is rendered
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelectedDate(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Logic to smoothly slide the horizontal bar to the selected date
  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
      // 50 (card width) + 14 (margin) = 64.0 pixels per item
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

  // Opens the native Calendar Popup
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7B61FF), // Header background
              onPrimary: Colors.white, // Header text
              onSurface: Colors.black, // Body text
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
    // Generates all days for the current selected month
    DateTime start = DateTime(selectedDate.year, selectedDate.month, 1);
    int daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    return List.generate(daysInMonth, (i) => start.add(Duration(days: i)));
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🌈 TOP GRADIENT HEADER
          Container(
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
          ),

          const SizedBox(height: 18),

          // 📅 MONTH + ICON ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "$monthName ${selectedDate.year}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 22,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔵 HORIZONTAL DATE SLIDER
          SizedBox(
            height: 110,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: dates.map((d) {
                  final isSelected =
                      d.day == selectedDate.day &&
                      d.month == selectedDate.month;

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
                        color: const Color(0xFF7D3CD9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2.0),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7B61FF,
                                  ).withOpacity(0.3),
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
          ),

          const SizedBox(height: 12),

          // 📋 TASK LIST
          Expanded(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemCount: tasks.length,
                              itemBuilder: (_, i) {
                                final task = tasks[i];
                                return TaskCard(
                                  title: task["title"] ?? "No Title",
                                  subtitle:
                                      task["description"] ?? "No Description",
                                  tags: _convertDbTags(task),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 80), // Space for bottom bar
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "No tasks for this date",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
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
    ];
    return names[m - 1];
  }

  String _weekdayName(int w) {
    const list = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return list[w - 1];
  }
}
