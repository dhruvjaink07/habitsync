import 'package:flutter/material.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart'; // Import your friend controller/provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderCollaboratorsPermissionSection extends ConsumerStatefulWidget {
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final bool reminder;
  final ValueChanged<bool> onReminderChanged;
  final VoidCallback? onAddCollaborator;
  final Color primary;
  final ThemeData theme;
  final ValueChanged<List<String>>? onCollaboratorsChanged; // <-- Add this

  const ReminderCollaboratorsPermissionSection({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.reminder,
    required this.onReminderChanged,
    required this.primary,
    required this.theme,
    this.onAddCollaborator,
    this.onCollaboratorsChanged, // <-- Add this
  });

  @override
  ConsumerState<ReminderCollaboratorsPermissionSection> createState() =>
      _ReminderCollaboratorsPermissionSectionState();
}

class _ReminderCollaboratorsPermissionSectionState
    extends ConsumerState<ReminderCollaboratorsPermissionSection> {
  final Set<String> selectedFriendIds = {};

  void _toggleCollaborator(String id) {
    setState(() {
      if (selectedFriendIds.contains(id)) {
        selectedFriendIds.remove(id);
      } else {
        selectedFriendIds.add(id);
      }
      // Notify parent of changes
      widget.onCollaboratorsChanged?.call(selectedFriendIds.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reminder Switch
          Row(
            children: [
              Icon(Icons.notifications_active_rounded,
                  color: widget.subTextColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Set Reminder',
                    style: widget.theme.textTheme.bodyLarge
                        ?.copyWith(color: widget.textColor, fontSize: 16)),
              ),
              Switch(
                value: widget.reminder,
                onChanged: widget.onReminderChanged,
                activeColor: widget.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Collaborators Section
          Row(
            children: [
              Icon(Icons.group_rounded, color: widget.subTextColor, size: 22),
              const SizedBox(width: 10),
              Text('Add Collaborators',
                  style: widget.theme.textTheme.bodyLarge
                      ?.copyWith(color: widget.textColor, fontSize: 16)),
              const Spacer(),
              friendsAsync.when(
                loading: () => const CircularProgressIndicator(strokeWidth: 2),
                error: (e, st) => const Icon(Icons.error, color: Colors.red),
                data: (friends) => Row(
                  children: [
                    ...friends.map((friend) {
                      final isSelected = selectedFriendIds.contains(friend.id);
                      return GestureDetector(
                        onTap: () =>
                            _toggleCollaborator(friend.id), // <-- Use this
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: isSelected
                                ? widget.primary
                                : Colors.grey.shade300,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: friend.avatar.startsWith('http')
                                  ? NetworkImage(friend.avatar)
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 16)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        onTap: () => widget.onAddCollaborator!(),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white10,
                          child: Icon(Icons.add,
                              color: widget.textColor, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedFriendIds.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: friendsAsync.maybeWhen(
                data: (friends) => friends
                    .where((f) => selectedFriendIds.contains(f.id))
                    .map((f) => Chip(
                          label: Text(f.name),
                          avatar: CircleAvatar(
                            backgroundImage: f.avatar.startsWith('http')
                                ? NetworkImage(f.avatar)
                                : AssetImage('assets/images/default_avatar.png')
                                    as ImageProvider,
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedFriendIds.remove(f.id);
                            });
                          },
                        ))
                    .toList(),
                orElse: () => [],
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Permission Section (unchanged)
          Row(
            children: [
              Icon(Icons.lock_rounded, color: widget.subTextColor, size: 22),
              const SizedBox(width: 10),
              Text('Permission Settings',
                  style: widget.theme.textTheme.bodyLarge
                      ?.copyWith(color: widget.textColor, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),
          // ...permission options...
        ],
      ),
    );
  }
}
