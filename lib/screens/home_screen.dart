import 'package:flutter/material.dart';
import 'home_page.dart';
import 'tasks_screen.dart';
import '../widgets/bottom_nav.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'new_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  // 1. Initialize directly here. This removes the 'late' risk entirely.
  final List<Widget> _pages = [
    const HomePage(),
    const TasksScreen(),
    const CalendarPage(),
    const SettingsPage(),
  ];

  // Handle tab changes
  void _onTabSelected(int idx) {
    setState(() {
      _index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack now has guaranteed access to _pages
      body: IndexedStack(index: _index, children: _pages),

      floatingActionButton: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFEFA8FF), Color(0xFF8E5BFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Push to NewTaskScreen - Supabase Streams handle the update
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewTaskScreen()),
            );
          },
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: _onTabSelected,
      ),
    );
  }
}
