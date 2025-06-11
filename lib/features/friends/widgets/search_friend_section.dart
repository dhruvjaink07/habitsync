import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart';

// --- Search Friends Section ---
class SearchFriendsSection extends ConsumerStatefulWidget {
  const SearchFriendsSection({super.key});

  @override
  ConsumerState<SearchFriendsSection> createState() =>
      _SearchFriendsSectionState();
}

class _SearchFriendsSectionState extends ConsumerState<SearchFriendsSection> {
  final TextEditingController _controller = TextEditingController();
  final Set<String> requestedIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchAsync = ref.watch(searchFriendsProvider);
    final friendsAsync = ref.watch(friendControllerProvider);

    // Get the list of friend IDs (if loaded)
    final friendIds = friendsAsync.maybeWhen(
      data: (friends) => friends.map((f) => f.id).toSet(),
      orElse: () => <String>{},
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search by username or email',
            prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          onChanged: (query) {
            ref.read(searchFriendsProvider.notifier).search(query);
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Search Results',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        searchAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (results) => results.isEmpty
              ? Center(
                  child: Text('No users found.',
                      style: theme.textTheme.bodyMedium))
              : Column(
                  children: results.map((user) {
                    final isFriend = friendIds.contains(user.id);
                    final isRequested = requestedIds.contains(user.id);
                    return Card(
                      color: theme.cardColor,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: (user.avatar != null &&
                                  user.avatar.startsWith('http'))
                              ? CachedNetworkImageProvider(user.avatar)
                              : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                        ),
                        title: Text(
                          user.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(user.username),
                        trailing: isFriend
                            ? const Text(
                                '😎 Friends',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : isRequested
                                ? const Text(
                                    'Requested',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      elevation: 0,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await ref
                                            .read(friendControllerProvider
                                                .notifier)
                                            .sendFriendRequest(user.id);
                                        setState(() {
                                          requestedIds.add(user.id);
                                        });
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              'Friend request sent to ${user.name}.',
                                              selectionColor: Colors.green,
                                            ),
                                          ));
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Failed to send request.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('+ Add Friend',
                                        style: TextStyle(fontSize: 15)),
                                  ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
