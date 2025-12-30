import 'package:flutter/material.dart';
import 'tag_chip.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<TagChip> tags;
  final bool isDone;
  final VoidCallback onStatusToggle;
  final VoidCallback onDelete;

  const TaskCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.isDone,
    required this.onStatusToggle,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TOP ROW: Radio + Title + Delete ---
          Row(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Aligns items vertically in the center
            children: [
              GestureDetector(
                onTap: onStatusToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDone
                          ? Color(0xFF855BE1)
                          : const Color(0xFFBFA6FF),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                    color: isDone ? Color(0xFF855BE1) : Colors.transparent,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.redAccent,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // --- CONTENT SECTION: Subtitle + Tags ---
          // Indented to align under the title (24px radio + 12px gap = 36px)
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 6, children: tags),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
