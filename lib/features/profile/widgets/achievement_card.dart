import 'package:flutter/material.dart';

class AchievementData {
  final String title;
  final IconData icon;
  final bool achieved;
  AchievementData(this.title, this.icon, this.achieved);
}

class AchievementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool achieved;

  const AchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.achieved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final accent =
        achieved ? theme.colorScheme.secondary : cardColor.withOpacity(0.7);
    final iconColor = achieved ? Colors.white : Colors.white38;
    final textColor = achieved ? Colors.white : Colors.white38;

    return Container(
      decoration: BoxDecoration(
        color: achieved ? accent : cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
