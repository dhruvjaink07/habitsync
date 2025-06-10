import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// --- Friends List Section ---
class FriendsListSection extends StatelessWidget {
  const FriendsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friends = [
      {
        'name': 'Sarah Wilson',
        'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
        'streak': 7,
      },
      {
        'name': 'Michael Chen',
        'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
        'streak': 5,
      },
      {
        'name': 'Emma Thompson',
        'avatar': 'https://randomuser.me/api/portraits/women/3.jpg',
        'streak': 3,
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        Text(
          'Your Friends (${friends.length})',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...friends.map((f) => Card(
              color: theme.cardColor,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      CachedNetworkImageProvider(f['avatar']! as String),
                ),
                title: Text(
                  f['name']! as String,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${f['streak']} days streak',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
                  onPressed: () {},
                ),
              ),
            )),
      ],
    );
  }
}
