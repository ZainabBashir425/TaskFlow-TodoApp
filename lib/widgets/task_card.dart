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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

          // Everything else in ONE COLUMN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: tags,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
