import 'package:flutter/material.dart';

class ButtonDivider extends StatelessWidget {
  const ButtonDivider({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? Colors.white24 : Colors.black12,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "OR",
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? Colors.white24 : Colors.black12,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
