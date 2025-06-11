import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart';

class FriendRequestsSection extends ConsumerWidget {
  const FriendRequestsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(friendRequestsProvider);
    final theme = Theme.of(context);

    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (requests) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          if (requests.isEmpty)
            Center(
              child: Text(
                'No incoming friend requests.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ...requests.map((user) => Card(
                color: theme.cardColor,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.username,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          ref
                              .read(friendRequestsProvider.notifier)
                              .acceptFriendRequest(user.id);
                        },
                        child: const Text('Accept'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          side: BorderSide(color: theme.dividerColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () {
                          ref
                              .read(friendRequestsProvider.notifier)
                              .rejectFriendRequest(user.id);
                        },
                        child: const Text('Decline'),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
