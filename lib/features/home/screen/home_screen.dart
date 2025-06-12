import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/color/strings.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/habits/controller/habit_controller.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/features/home/widgets/app_bar.dart';
import 'package:habitsync/features/home/widgets/habit_detail_dialog.dart';
import 'package:habitsync/features/home/widgets/streak_indicator.dart';
import 'package:habitsync/features/home/widgets/tab_indicator.dart';
import 'package:habitsync/features/home/widgets/habit_card.dart';
import 'package:habitsync/services/profile_cache_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onAddHabitTap;
  const HomeScreen({super.key, this.onProfileTap, this.onAddHabitTap});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? _user;

  Future<void> _loadProfile() async {
    final user = await ProfileCacheService.getCachedUserProfile();
    setState(() {
      _user = user;
    });
    if (user != null) {
      // Fetch habits for this user
      await ref
          .read(habitControllerProvider.notifier)
          .getHabitsByOwner(user.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _navigateToAddHabit(BuildContext context) async {
    widget.onAddHabitTap!();
    if (_user != null) {
      await ref
          .read(habitControllerProvider.notifier)
          .getHabitsByOwner(_user!.id);
    }
  }

  void _showHabitDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => HabitDetailDialog(
        habit: habit,
        onUpdate: (updatedHabit) async {
          await ref
              .read(habitControllerProvider.notifier)
              .updateHabit(updatedHabit);
          // Optionally show a snackbar
          if (_user != null) {
            await ref
                .read(habitControllerProvider.notifier)
                .getHabitsByOwner(_user!.id);
          }
        },
        onDelete: () async {
          Navigator.of(context).pop();
          await ref
              .read(habitControllerProvider.notifier)
              .deleteHabit(habit.id, habit.owner);
          // Optionally show a snackbar
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final Gradient backgroundGradient = isDark
        ? AppColors.darkBackgroundGradient
        : AppColors.lightBackgroundGradient;

    final habitsAsync = ref.watch(habitControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: HS_AppBar(
          url: _user?.avatar ?? 'https://i.pravatar.cc/150?img=3',
          username: _user?.name ?? AppStrings.username,
          greet: AppStrings.greet,
          onProfileTap: widget.onProfileTap,
        ),
        centerTitle: true,
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (habits) {
          if (habits.isEmpty) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: backgroundGradient),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_dissatisfied,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    const Text(
                      "No habits yet!",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Start building your habits now.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToAddHabit(context),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Create Habit"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return DefaultTabController(
            length: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: backgroundGradient),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    StreakIndicator(
                      screenHeigt: screenHeight,
                      isDark: isDark,
                      screenWidth: screenWidth,
                    ),
                    const SizedBox(height: 24),
                    TabIndicator(isDark: isDark),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // All
                          ListView.builder(
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              return HabitCard(
                                habit: habit,
                                height: screenHeight,
                                onTap: () => _showHabitDialog(context, habit),
                              );
                            },
                          ),
                          // Personal
                          ListView.builder(
                            itemCount: habits
                                .where((h) =>
                                    h.sharedWith.isEmpty &&
                                    h.owner == _user?.id)
                                .length,
                            itemBuilder: (context, index) {
                              final habit = habits
                                  .where((h) =>
                                      h.sharedWith.isEmpty &&
                                      h.owner == _user?.id)
                                  .toList()[index];
                              return HabitCard(
                                habit: habit,
                                height: screenHeight,
                                onTap: () => _showHabitDialog(context, habit),
                              );
                            },
                          ),
                          // Shared
                          ListView.builder(
                            itemCount: habits
                                .where((h) =>
                                    h.sharedWith.isNotEmpty &&
                                    h.owner == _user?.id)
                                .length,
                            itemBuilder: (context, index) {
                              final habit = habits
                                  .where((h) =>
                                      h.sharedWith.isNotEmpty &&
                                      h.owner == _user?.id)
                                  .toList()[index];
                              return HabitCard(
                                habit: habit,
                                height: screenHeight,
                                onTap: () => _showHabitDialog(context, habit),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
