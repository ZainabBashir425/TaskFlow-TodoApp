import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            _buildItem(icon: Icons.home, label: 'Home', idx: 0),
            _buildItem(icon: Icons.check_box_outlined, label: 'Tasks', idx: 1),

            const Spacer(flex: 1), // space for FAB, responsive

            _buildItem(icon: Icons.calendar_month, label: 'Calendar', idx: 2),
            _buildItem(icon: Icons.settings, label: 'Settings', idx: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({required IconData icon, required String label, required int idx}) {
    final active = idx == currentIndex;

    return SizedBox(
      width: 70, // FIXED width prevents overflow!
      child: InkWell(
        onTap: () => onTap(idx),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? const Color(0xFF8A38F5) : Colors.grey,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: active ? const Color(0xFF7B61FF) : Colors.grey,
                  fontSize: 11, // decreased to eliminate overflow
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
