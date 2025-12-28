import 'package:flutter/material.dart';
import 'tag_chip.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<TagChip> tags;

  const TaskCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Detect if the app is currently in Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // 2. Flip background color: Dark Grey (0xFF1E1E1E) for Dark Mode, White for Light Mode
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // 3. Make shadows subtler or invisible in dark mode
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left circle (checkbox)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBFA6FF), width: 2),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    // 4. Set title text to white in Dark Mode
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    // 5. Set subtitle to light grey in Dark Mode
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                // Tags
                Wrap(spacing: 8, runSpacing: 6, children: tags),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
