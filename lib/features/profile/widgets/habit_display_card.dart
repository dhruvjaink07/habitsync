import 'package:flutter/material.dart';

// Habit Card Widget (responsive, public)
class HabitCard extends StatelessWidget {
  final String title;
  final String progress;
  final String time;
  final List<String> avatars;

  const HabitCard({
    super.key,
    required this.title,
    required this.progress,
    required this.time,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;

    // Show max 3 avatars, rest as +N
    const maxAvatars = 3;
    final extra = avatars.length > maxAvatars ? avatars.length - maxAvatars : 0;
    final shownAvatars = avatars.take(maxAvatars).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            progress,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subTextColor,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...shownAvatars.map((url) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(url),
                    ),
                  )),
              if (extra > 0)
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '+$extra',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              const Spacer(),
              Icon(Icons.access_time, color: subTextColor, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
