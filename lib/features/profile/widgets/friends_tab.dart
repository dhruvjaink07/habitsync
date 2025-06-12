import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/features/profile/widgets/friend_card.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart';

// FRIENDS TAB
class FriendsTab extends ConsumerStatefulWidget {
  final VoidCallback? onAddFriend;
  const FriendsTab({super.key, this.onAddFriend});

  @override
  ConsumerState<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends ConsumerState<FriendsTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    final friendsAsync = ref.watch(friendControllerProvider);

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
                onPressed: () => widget.onAddFriend!(),
                icon: Icon(Icons.person_add,
                    color: theme.colorScheme.secondary, size: 18),
                label: Text('Invite Friends',
                    style: TextStyle(color: theme.colorScheme.secondary)),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          friendsAsync.when(
            data: (friends) => friends.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        "No friends yet.",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                : Column(
                    children: friends
                        .map((user) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: FriendCard(
                                avatarUrl: user.avatar ?? '',
                                name: user.name ?? '',
                                username: '@${user.username ?? ''}',
                                sharedCount: user.streak ?? 0,
                                // timeAgo: user. ?? '',
                              ),
                            ))
                        .toList(),
                  ),
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            )),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  "Failed to load friends",
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
