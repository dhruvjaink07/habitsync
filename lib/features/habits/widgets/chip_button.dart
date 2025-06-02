import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;
  const ChipButton(
      {required this.label, this.selected = false, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = theme.cardColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? (color ?? theme.primaryColor) : cardColor,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(color: color ?? theme.primaryColor, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
