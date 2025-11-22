import 'package:flutter/material.dart';
import 'home_page.dart';
import 'tasks_screen.dart';
import '../widgets/bottom_nav.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'new_task_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TasksScreen(),
    CalendarPage(),
    SettingsPage(),
  ];

  void _onTabSelected(int idx) {
    setState(() => _index = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to New Task Screen instead of showing snackbar
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewTaskScreen()),
          );
        },
        backgroundColor: const Color(0xFFAD7BFF),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: _onTabSelected,
      ),
    );
  }
}