import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/friends/controller/friend_controller.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/services/profile_cache_service.dart';

class HabitDetailDialog extends ConsumerStatefulWidget {
  final Habit habit;
  final Future<void> Function(Habit updatedHabit) onUpdate;
  final VoidCallback onDelete;

  const HabitDetailDialog({
    super.key,
    required this.habit,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  ConsumerState<HabitDetailDialog> createState() => _HabitDetailDialogState();
}

class _HabitDetailDialogState extends ConsumerState<HabitDetailDialog> {
  late bool isEditing;
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  List<User>? sharedUsers;
  User? ownerUser;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    _titleController = TextEditingController(text: widget.habit.title);
    _notesController = TextEditingController(text: widget.habit.notes);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final currentUser = await ProfileCacheService.getCachedUserProfile();
    final friendsAsync = ref.read(friendControllerProvider);

    // Owner logic
    if (widget.habit.owner == currentUser?.id) {
      ownerUser = currentUser;
    } else if (friendsAsync is AsyncData<List<User>>) {
      ownerUser = friendsAsync.value.firstWhere(
        (u) => u.id == widget.habit.owner,
      );
    }

    // Collaborators logic
    sharedUsers = [];
    if (friendsAsync is AsyncData<List<User>>) {
      for (final id in widget.habit.sharedWith) {
        if (id == currentUser?.id) {
          sharedUsers!.add(currentUser!);
        } else {
          final user = friendsAsync.value.firstWhere(
            (u) => u.id == id,
          );
          if (user != null) sharedUsers!.add(user);
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget valueWidget}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: valueWidget,
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _save() async {
    final updatedHabit = widget.habit.copyWith(
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
    );
    await widget.onUpdate(updatedHabit);
    setState(() {
      isEditing = false;
    });
    Navigator.of(context).pop(); // Optionally close dialog after save
  }

  Widget _buildInfoTile(
      {required IconData icon, required Widget title, Widget? trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      leading:
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      title: title,
      trailing: trailing,
      dense: true,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        Color(int.parse(widget.habit.color.replaceFirst('#', '0xff')));
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  radius: 32,
                  child: Icon(Icons.emoji_events, color: color, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.habit.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              if (widget.habit.notes.isNotEmpty)
                Center(
                  child: Text(
                    widget.habit.notes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 18),
              Text("Details",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Card(
                color: isDark
                    ? AppColors.cardDark.withOpacity(0.7)
                    : AppColors.cardLight.withOpacity(0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.repeat,
                      title: Text(widget.habit.repeatPattern,
                          style: theme.textTheme.bodyLarge),
                    ),
                    _buildInfoTile(
                      icon: Icons.calendar_today,
                      title: Text(
                          "${widget.habit.createdAt.toLocal()}"
                              .split('.')
                              .first,
                          style: theme.textTheme.bodyLarge),
                    ),
                    _buildInfoTile(
                      icon: Icons.alarm,
                      title: Text(
                        widget.habit.reminders.isNotEmpty
                            ? widget.habit.reminders.join('\n')
                            : "None",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text("Collaborators",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Card(
                color: isDark
                    ? AppColors.cardDark.withOpacity(0.7)
                    : AppColors.cardLight.withOpacity(0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.person,
                      title: UserChip(
                        name: widget.habit.owner.name,
                        avatarUrl: widget.habit.owner.avatar,
                      ),
                    ),
                    _buildInfoTile(
                      icon: Icons.group,
                      title: widget.habit.sharedWith.isEmpty
                          ? const Text("None")
                          : Wrap(
                              spacing: 4,
                              children: widget.habit.sharedWith
                                  .map((u) => UserChip(
                                      name: u.name, avatarUrl: u.avatar))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: isEditing ? _save : _toggleEdit,
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    label: Text(isEditing ? "Save" : "Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserChip extends StatelessWidget {
  final String name;
  final String avatarUrl;
  const UserChip({super.key, required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundImage: avatarUrl.startsWith('http')
            ? NetworkImage(avatarUrl)
            : AssetImage('assets/images/default_avatar.png') as ImageProvider,
        radius: 12,
      ),
      label: Text(name, style: const TextStyle(fontSize: 13)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
    );
  }
}
