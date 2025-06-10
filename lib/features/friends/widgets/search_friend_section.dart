import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';

// --- Search Friends Section ---
class SearchFriendsSection extends StatefulWidget {
  const SearchFriendsSection({super.key});

  @override
  State<SearchFriendsSection> createState() => _SearchFriendsSectionState();
}

class _SearchFriendsSectionState extends State<SearchFriendsSection> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _results = [
    {
      'name': 'David Kim',
      'avatar': 'https://randomuser.me/api/portraits/men/4.jpg',
      'status': 'Friend'
    },
    {
      'name': 'Lisa Anderson',
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
      'status': 'Add'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'Search Friends',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
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
            // TODO: Implement search logic
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
        ..._results.map((r) => Card(
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
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(r['avatar']!),
                ),
                title: Text(
                  r['name']!,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                trailing: r['status'] == 'Friend'
                    ? Text('Friend',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.hintColor))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // TODO: Send friend request
                        },
                        child: const Text('+ Add Friend',
                            style: TextStyle(fontSize: 15)),
                      ),
              ),
            )),
      ],
    );
  }
}
