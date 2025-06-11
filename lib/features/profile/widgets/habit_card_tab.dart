import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/features/profile/widgets/habit_display_card.dart';

// Habits Tab Widget (responsive)
class HabitsTab extends StatelessWidget {
  final List<Habit> habits;
  final VoidCallback? onAddHabit;

  const HabitsTab({super.key, required this.habits, this.onAddHabit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              ...habits.map((habit) => HabitDisplayCard(
                    title: habit.title,
                    progress:
                        '', // You can calculate progress if you have the data
                    time: habit.reminders.isNotEmpty
                        ? TimeOfDay.fromDateTime(
                                DateTime.parse(habit.reminders.first))
                            .format(context)
                        : '',
                    avatars: habit
                        .sharedWith, // If you want to show collaborators' avatars, map them here
                  )),
              // Add New Habit Card
              GestureDetector(
                onTap: onAddHabit,
                child: DottedBorder(
                  color: theme.dividerColor,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  dashPattern: const [6, 3],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            color: textColor.withOpacity(0.5), size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'Add New Habit',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
