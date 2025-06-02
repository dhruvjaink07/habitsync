import 'package:flutter/material.dart';
import 'package:habitsync/features/habits/screens/add_habit_screen.dart';
import 'package:habitsync/features/habits/widgets/chip_button.dart';

// Reminder, Collaborators, Permission Section
class ReminderCollaboratorsPermissionSection extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final bool reminder;
  final ValueChanged<bool> onReminderChanged;
  final String selectedPermission;
  final List<String> permissionOptions;
  final ValueChanged<String> onPermissionSelected;
  final Color primary;
  final ThemeData theme;

  const ReminderCollaboratorsPermissionSection({
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.reminder,
    required this.onReminderChanged,
    required this.selectedPermission,
    required this.permissionOptions,
    required this.onPermissionSelected,
    required this.primary,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_rounded,
                  color: subTextColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Set Reminder',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: textColor, fontSize: 16)),
              ),
              Switch(
                value: reminder,
                onChanged: onReminderChanged,
                activeColor: primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.group_rounded, color: subTextColor, size: 22),
              const SizedBox(width: 10),
              Text('Add Collaborators',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: textColor, fontSize: 16)),
              const Spacer(),
              Row(
                children: [
                  Avatar(),
                  const SizedBox(width: 4),
                  Avatar(),
                  const SizedBox(width: 4),
                  Avatar(),
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.add, color: textColor, size: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.lock_rounded, color: subTextColor, size: 22),
              const SizedBox(width: 10),
              Text('Permission Settings',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: textColor, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(permissionOptions.length, (i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < permissionOptions.length - 1 ? 10 : 0),
                child: ChipButton(
                  label: permissionOptions[i],
                  selected: selectedPermission == permissionOptions[i],
                  color: primary,
                  onTap: () => onPermissionSelected(permissionOptions[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
