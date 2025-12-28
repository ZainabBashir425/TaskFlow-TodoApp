import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime(2025, 11, 1);
  late Map<String, List<Map<String, dynamic>>> taskMap;

  @override
  void initState() {
    super.initState();
    _initializeTaskMap();
  }

  void _initializeTaskMap() {
    taskMap = {
      "2025-11-01": [
        {
          "title": "Welcome to TaskFlow!",
          "subtitle": "Complete this task to get started",
          "tags": [
            {"text": 'Getting Started', "color": 0xFF8A38F5, "outlined": false},
            {"text": 'high', "color": 0xFFD93C65, "outlined": false},
            {"text": 'Oct 18', "color": 0xFFE6E9F2, "outlined": true},
          ],
        },
        {
          "title": "UI Design Task",
          "subtitle": "Work on the new UI enhancements",
          "tags": [
            {"text": 'Design', "color": 0xFF50B27A, "outlined": false},
            {"text": 'medium', "color": 0xFFEFCB0D, "outlined": false},
          ],
        },
        {
          "title": "Fix Calendar Screen",
          "subtitle": "Match design exactly as provided",
          "tags": [
            {"text": 'Bug Fix', "color": 0xFFEFCB0D, "outlined": false},
          ],
        },
      ],
      "2025-11-02": [
        {
          "title": "Another Task",
          "subtitle": "This is for November 2nd",
          "tags": [
            {"text": 'Test', "color": 0xFFD7E8FF, "outlined": false},
          ],
        },
      ],
    };
    print("TaskMap initialized with keys: ${taskMap.keys.toList()}");
  }

  List<DateTime> getDisplayedDates() {
    return List.generate(15, (i) => DateTime(2025, 11, i + 1));
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<TagChip> _convertTags(List<dynamic> tagData) {
    return tagData.map((tag) {
      return TagChip(
        text: tag['text'],
        color: Color(tag['color']),
        outlined: tag['outlined'] ?? false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Re-initialize if empty (hot reload fix)
    if (taskMap.isEmpty) {
      _initializeTaskMap();
    }

    final dates = getDisplayedDates();
    final key = _formatDate(selectedDate);
    final tasks = taskMap[key] ?? [];

    print("Building with key: $key");
    print("Tasks found: ${tasks.length}");
    print("All taskMap keys: ${taskMap.keys.toList()}");

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 22,
                  color: Colors.black87,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔵 HORIZONTAL DATE CARDS (Now scrollable)
          SizedBox(
            height: 110,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: dates.map((d) {
                  final isSelected = d.day == selectedDate.day;
                  final dateKey = _formatDate(d);
                  final hasTasks =
                      taskMap.containsKey(dateKey) &&
                      taskMap[dateKey]!.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      print("Tapped on: $dateKey, has tasks: $hasTasks");
                      setState(() => selectedDate = d);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 14),
                      width: 50,
                      height: isSelected ? 110 : 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7D3CD9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white, // grey border
                          width: 2.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Color(0xFF7B61FF).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // White dot only if selected AND has tasks
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
                          // If not selected but has tasks, add empty space to maintain alignment
                          if (!isSelected && hasTasks)
                            const SizedBox(
                              height: 12,
                            ), // Same height as dot + margin
                          // If no tasks, add minimal space
                          if (!hasTasks) const SizedBox(height: 6),
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

          // SELECTED DATE + TASK COUNT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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

          const SizedBox(height: 14),

          // TASK LIST
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No tasks for this date",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Date: $key",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemCount: tasks.length,
                    itemBuilder: (_, i) {
                      final task = tasks[i];
                      return TaskCard(
                        title: task["title"] ?? "No Title",
                        subtitle: task["subtitle"] ?? "No Description",
                        tags: _convertTags(task["tags"]),
                      );
                    },
                  ),
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
