import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';

class HabitDetailDialog extends StatefulWidget {
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
  State<HabitDetailDialog> createState() => _HabitDetailDialogState();
}

class _HabitDetailDialogState extends State<HabitDetailDialog> {
  late bool isEditing;
  late TextEditingController _titleController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    _titleController = TextEditingController(text: widget.habit.title);
    _notesController = TextEditingController(text: widget.habit.notes);
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
                child: isEditing
                    ? TextFormField(
                        controller: _titleController,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                        ),
                      )
                    : Text(
                        widget.habit.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              if (widget.habit.notes.isNotEmpty || isEditing) ...[
                const SizedBox(height: 8),
                Center(
                  child: isEditing
                      ? TextFormField(
                          controller: _notesController,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.subtextDark
                                : AppColors.subtextLight,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Notes",
                          ),
                        )
                      : Text(
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
              ],
              const Divider(height: 32, thickness: 1),
              _buildInfoRow(
                context,
                icon: Icons.repeat,
                label: "Repeat",
                valueWidget: Text(widget.habit.repeatPattern,
                    style: theme.textTheme.bodyLarge),
              ),
              _buildInfoRow(
                context,
                icon: Icons.calendar_today,
                label: "Created",
                valueWidget: Text(
                    "${widget.habit.createdAt.toLocal()}".split('.').first,
                    style: theme.textTheme.bodyLarge),
              ),
              _buildInfoRow(
                context,
                icon: Icons.alarm,
                label: "Reminders",
                valueWidget: Text(
                  widget.habit.reminders.isNotEmpty
                      ? widget.habit.reminders.join('\n')
                      : "None",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.person,
                label: "Owner",
                valueWidget:
                    Text(widget.habit.owner, style: theme.textTheme.bodyLarge),
              ),
              _buildInfoRow(
                context,
                icon: Icons.group,
                label: "Shared With",
                valueWidget: Text(
                  widget.habit.sharedWith.isNotEmpty
                      ? widget.habit.sharedWith.join(', ')
                      : "None",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isEditing
                      ? ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save),
                          label: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _toggleEdit,
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
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
