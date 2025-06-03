import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;
  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final cardColor = theme.cardColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? (color ?? theme.primaryColor) : cardColor,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: color ?? theme.primaryColor, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: iconColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
