import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const StatCard({required this.title, required this.value, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0,6))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFEAE4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CircleAvatar(backgroundColor: Color(0xFFEAE4FF) ,child: Icon(icon, color: Color(0xFF855BE1))),
          )
        ],
      ),
    );
  }
}
