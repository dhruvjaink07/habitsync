import 'package:flutter/material.dart';
import 'package:habitsync/features/profile/widgets/achievements_tab.dart';
import 'package:habitsync/features/profile/widgets/action_button.dart';
import 'package:habitsync/features/profile/widgets/friends_tab.dart';
import 'package:habitsync/features/profile/widgets/habit_card_tab.dart';
import 'package:habitsync/features/profile/widgets/stats_card.dart';
import 'package:habitsync/features/settings/screen/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onAddHabitTap;

  const ProfileScreen({super.key, this.onAddHabitTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;
    final cardColor = theme.cardColor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Settings icon at the top right of the body
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.settings, color: textColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()));
                      },
                    ),
                  ],
                ),
              ),
              // Avatar
              CircleAvatar(
                radius: 48,
                backgroundImage:
                    const NetworkImage('https://i.pravatar.cc/150?img=3'),
                backgroundColor: cardColor,
              ),
              const SizedBox(height: 12),
              // Name
              Text(
                'Sarah Anderson',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              // Username
              Text(
                '@sarahloves2grow',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Habit Master',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Streak & Check-ins
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatCard(
                    icon: Icons.local_fire_department,
                    label: 'Current Streak',
                    value: '12',
                    color1: Colors.blueAccent,
                    color2: Colors.purpleAccent,
                  ),
                  SizedBox(width: 16),
                  StatCard(
                    icon: Icons.check_circle,
                    label: 'Weekly Check-ins',
                    value: '85%',
                    color1: Colors.pinkAccent,
                    color2: Colors.purpleAccent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                          label: 'Edit Goals', icon: Icons.flag, onTap: () {}),
                      const SizedBox(width: 8),
                      ActionButton(
                          label: 'Share Profile',
                          icon: Icons.share,
                          onTap: () {}),
                      const SizedBox(width: 8),
                      ActionButton(
                          label: 'Sync Habits', icon: Icons.sync, onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tabs
              TabBar(
                indicatorColor: theme.colorScheme.secondary,
                labelColor: textColor,
                unselectedLabelColor: subTextColor,
                tabs: const [
                  Tab(text: 'My Habits'),
                  Tab(text: 'Friends'),
                  Tab(text: 'Achievements'),
                ],
              ),
              SizedBox(
                height: 400, // Adjust as needed
                child: TabBarView(
                  children: [
                    HabitsTab(onAddHabit: onAddHabitTap), // Pass callback here
                    FriendsTab(),
                    AchievementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
