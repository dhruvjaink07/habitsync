import 'package:flutter/material.dart';
import 'package:habitsync/features/profile/widgets/friend_card.dart';

// FRIENDS TAB
class FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Friends',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: textColor)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.person_add,
                    color: theme.colorScheme.secondary, size: 18),
                label: Text('Invite Friends',
                    style: TextStyle(color: theme.colorScheme.secondary)),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FriendCard(
            avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
            name: 'Emma Wilson',
            username: '@emmaw',
            sharedCount: 5,
            timeAgo: '2m ago',
          ),
          const SizedBox(height: 8),
          FriendCard(
            avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
            name: 'Michael Chen',
            username: '@mchen',
            sharedCount: 3,
            timeAgo: '1h ago',
          ),
        ],
      ),
    );
  }
}
