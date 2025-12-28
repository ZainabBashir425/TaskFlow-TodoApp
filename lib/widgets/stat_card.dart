import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // 2. Use dark surface color or white based on theme
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8), // Adjusted slightly for better spacing
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  // 3. Lighten the label text in dark mode
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  // 4. Set number value to white in dark mode
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const Spacer(),
          // 5. Adjust the icon container background
          Container(
            padding: const EdgeInsets.all(4), // Added padding for the icon box
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D264D) : const Color(0xFFEAE4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF855BE1), size: 26),
          ),
        ],
      ),
    );
  }
}
