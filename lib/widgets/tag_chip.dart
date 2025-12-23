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
    final double borderWidth = 2.0;

    if (outlined) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400, width: borderWidth),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // NON–OUTLINED VERSION (updated)
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, // White BG
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,       // Border = chip color
          width: borderWidth, // Increased width
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,       // Text color = border color
        ),
      ),
    );
  }
}
