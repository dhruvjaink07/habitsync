import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String username;
  final int sharedCount;

  const FriendCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.username,
    required this.sharedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: textColor, fontWeight: FontWeight.bold)),
                Text(username,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: subTextColor)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$sharedCount shared',
                  style: theme.textTheme.bodySmall?.copyWith(color: textColor)),
            ],
          ),
        ],
      ),
    );
  }
}
