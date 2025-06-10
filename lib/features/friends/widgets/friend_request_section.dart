import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';

// --- Friend Requests Section ---
class FriendRequestsSection extends StatefulWidget {
  const FriendRequestsSection({super.key});

  @override
  State<FriendRequestsSection> createState() => _FriendRequestsSectionState();
}

class _FriendRequestsSectionState extends State<FriendRequestsSection> {
  int _tabIndex = 0; // 0: Incoming, 1: Outgoing

  final incoming = [
    {
      'name': 'Alex Johnson',
      'avatar': 'https://randomuser.me/api/portraits/men/6.jpg',
      'sent': '2 days ago'
    },
    {
      'name': 'Chris Evans',
      'avatar': 'https://randomuser.me/api/portraits/men/8.jpg',
      'sent': '1 day ago'
    },
  ];
  final outgoing = [
    {
      'name': 'Rachel Lee',
      'avatar': 'https://randomuser.me/api/portraits/women/7.jpg',
      'sent': '3 days ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requests = _tabIndex == 0 ? incoming : outgoing;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        const SizedBox(height: 8),
        Text(
          'Friend Requests',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _tabIndex == 0 ? AppColors.primary : theme.cardColor,
                  foregroundColor: _tabIndex == 0
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => setState(() => _tabIndex = 0),
                child: Text('Incoming (${incoming.length})'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _tabIndex == 1 ? AppColors.primary : theme.cardColor,
                  foregroundColor: _tabIndex == 1
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => setState(() => _tabIndex = 1),
                child: Text('Outgoing (${outgoing.length})'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...requests.map((r) => Card(
              color: theme.cardColor,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(r['avatar']!),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r['name']!,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sent ${r['sent']}',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ),
                    if (_tabIndex == 0) ...[
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
                        onPressed: () {},
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
                        onPressed: () {},
                        child: const Text('Decline'),
                      ),
                    ] else ...[
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () {},
                        child: const Text('Cancel Request'),
                      ),
                    ]
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
