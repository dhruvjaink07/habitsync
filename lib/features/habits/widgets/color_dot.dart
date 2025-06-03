import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  const ColorDot({super.key, required this.color, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final dotColor = isDark ? Colors.white : Colors.black;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected ? Border.all(color: dotColor, width: 3) : null,
      ),
    );
  }
}
