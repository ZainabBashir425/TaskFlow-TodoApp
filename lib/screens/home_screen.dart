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
  // 1. Add a GlobalKey to access HomePage's state
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  void _onTabSelected(int idx) {
    setState(() => _index = idx);
  }

  @override
  Widget build(BuildContext context) {
    // 2. Update the pages list to use the key
    final List<Widget> _pages = [
      HomePage(key: _homeKey), // Pass the key here
      const TasksScreen(),
      const CalendarPage(),
      const SettingsPage(),
    ];

    return Scaffold(
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
          onPressed: () async {
            // 3. Open the screen and wait for the result
            final result = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewTaskScreen()),
            );

            // 4. If a task was added, call the refresh function in HomePage
            if (result == true) {
              _homeKey.currentState?.refreshData();
            }
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
