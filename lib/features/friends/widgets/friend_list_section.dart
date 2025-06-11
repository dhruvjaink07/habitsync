import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart';

class FriendsListSection extends ConsumerWidget {
  const FriendsListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendControllerProvider);

    final theme = Theme.of(context);

    return friendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (friends) => ListView(
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
                    backgroundImage: CachedNetworkImageProvider(f.avatar),
                  ),
                  title: Text(
                    f.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${f.streak ?? 0} days streak',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
                    onPressed: () {
                      // Optionally show remove friend dialog
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
