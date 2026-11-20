import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickLinkItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 38,
            decoration: BoxDecoration(
              color: lightBorder,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: blue, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}