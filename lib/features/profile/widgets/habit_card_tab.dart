import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:habitsync/features/profile/widgets/habit_display_card.dart';

// Habits Tab Widget (responsive)
class HabitsTab extends StatelessWidget {
  final VoidCallback? onAddHabit;

  const HabitsTab({super.key, this.onAddHabit});

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
              const HabitCard(
                title: 'Morning Meditation',
                progress: '12/30 days',
                time: '7:00 AM',
                avatars: [
                  'https://randomuser.me/api/portraits/men/1.jpg',
                  'https://randomuser.me/api/portraits/women/2.jpg',
                  'https://randomuser.me/api/portraits/men/3.jpg',
                ],
              ),
              const HabitCard(
                title: 'Read Books',
                progress: '8/30 days',
                time: '8:00 PM',
                avatars: [
                  'https://randomuser.me/api/portraits/women/4.jpg',
                  'https://randomuser.me/api/portraits/men/5.jpg',
                ],
              ),
              const HabitCard(
                title: 'Exercise',
                progress: '15/30 days',
                time: '6:00 AM',
                avatars: [
                  'https://randomuser.me/api/portraits/men/6.jpg',
                  'https://randomuser.me/api/portraits/women/7.jpg',
                ],
              ),
              // Add New Habit Card
              GestureDetector(
                onTap: onAddHabit, // This will now switch the tab!
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
