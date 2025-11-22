import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import '../widgets/tag_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildHeader(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          // top row with avatar & greeting
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.yellow.shade600,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Good Evening!", style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text("Zack Snyder",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
              const Spacer(),
              // small icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text("Today's Progress", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          // progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: 0.0,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
      child: Row(
        children: const [
          Expanded(child: StatCard(title: 'Total Task', value: '2', icon: Icons.access_time)),
          SizedBox(width: 12),
          Expanded(child: StatCard(title: 'Completed', value: '0', icon: Icons.check_circle)),
        ],
      ),
    );
  }

  Widget _buildTodayTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // heading
          Row(
            children: const [
              Text("Today's Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.repeat, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 12),
          // task cards
          TaskCard(
            title: "Welcome to TaskFlow!",
            subtitle: "Complete this task to get started",
            tags: [
              TagChip(text: 'Getting Started', color: Color(0xFFBFA6FF)),
              TagChip(text: 'high', color: Color(0xFFFFC6D1)),
              TagChip(text: 'Oct 18', color: Color(0xFFE6E9F2), outlined: true),
            ],
          ),
          const SizedBox(height: 10),
          TaskCard(
            title: "Create Your first task",
            subtitle: "Tap the + button to add a new task",
            tags: [
              TagChip(text: 'Tutorial', color: Color(0xFFD9F6E8)),
              TagChip(text: 'medium', color: Color(0xFFFFF2C8)),
              TagChip(text: 'Oct 18', color: Color(0xFFE6E9F2), outlined: true),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // page scaffold with scrollable content
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStatsRow(),
            _buildTodayTasks(),
            const SizedBox(height: 80), // space for bottom nav
          ],
        ),
      ),
    );
  }
}
