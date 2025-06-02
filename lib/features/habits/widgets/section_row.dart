import 'package:flutter/material.dart';

class SectionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? textColor;
  final Color? subTextColor;
  final bool showArrow;
  const SectionRow({
    required this.icon,
    required this.title,
    required this.value,
    this.textColor,
    this.subTextColor,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: subTextColor ?? Colors.white70, size: 22),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(color: textColor ?? Colors.white, fontSize: 16)),
        const Spacer(),
        Text(value,
            style:
                TextStyle(color: subTextColor ?? Colors.white70, fontSize: 15)),
        if (showArrow) ...[
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              color: Colors.white24, size: 22),
        ],
      ],
    );
  }
}
