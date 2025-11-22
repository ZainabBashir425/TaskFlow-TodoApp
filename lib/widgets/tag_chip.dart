import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool outlined;
  const TagChip({required this.text, required this.color, this.outlined = false, super.key});

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}
