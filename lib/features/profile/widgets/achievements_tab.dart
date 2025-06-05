import 'package:flutter/material.dart';
import 'package:habitsync/features/profile/widgets/achievement_card.dart';

// ACHIEVEMENTS TAB
class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    // Example achievements data
    final achievements = [
      AchievementData('7-Day Streak', Icons.local_fire_department, true),
      AchievementData('Team Builder', Icons.group, true),
      AchievementData('Early Bird', Icons.wb_twighlight, true),
      AchievementData('Goal Crusher', Icons.flag, false),
      AchievementData('Social Butterfly', Icons.people_alt, false),
      AchievementData('Perfect Week', Icons.emoji_events, false),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final data = achievements[index];
              return AchievementCard(
                title: data.title,
                icon: data.icon,
                achieved: data.achieved,
              );
            },
          ),
        ],
      ),
    );
  }
}
