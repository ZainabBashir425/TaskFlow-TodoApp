import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool outlined;

  const TagChip({
    required this.text,
    required this.color,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double borderWidth = 2.0;

    // Outlined version (usually used for Due Date)
    if (outlined) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // 2. Adjust border and background for dark mode
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
            width: borderWidth,
          ),
          color: isDark ? Colors.white10 : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: isDark ? Colors.white60 : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // NON–OUTLINED VERSION (Category / Priority)
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        // 3. Instead of pure white, use a very subtle version of the chip's color in dark mode
        color: isDark ? color.withOpacity(0.0) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: borderWidth),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14, // Scaled down slightly for better fit
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
