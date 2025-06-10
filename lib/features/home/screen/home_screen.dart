import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/color/strings.dart';
import 'package:habitsync/data/dummy_task_data.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/home/widgets/app_bar.dart';
import 'package:habitsync/features/home/widgets/streak_indicator.dart';
import 'package:habitsync/features/home/widgets/tab_indicator.dart';
import 'package:habitsync/features/home/widgets/task_card.dart';
import 'package:habitsync/services/profile_cache_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  const HomeScreen({super.key, this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;

  Future<void> _loadProfile() async {
    final user = await ProfileCacheService.getCachedUserProfile();
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
      body: DefaultTabController(
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
                        itemCount: DummyTaskData()
                            .dummyTasks
                            .length, // Example item count
                        itemBuilder: (context, index) {
                          final task = DummyTaskData().dummyTasks[index];
                          return TaskCard(task: task, heigth: screenHeight);
                        },
                      ),

                      // Personal
                      ListView.builder(
                        itemCount: DummyTaskData()
                            .dummyTasks
                            .length, // Example item count
                        itemBuilder: (context, index) {
                          final task = DummyTaskData().dummyTasks[index];
                          if (!task.isShared) {
                            return TaskCard(task: task, heigth: screenHeight);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      // Shared
                      ListView.builder(
                        itemCount: DummyTaskData()
                            .dummyTasks
                            .length, // Example item count
                        itemBuilder: (context, index) {
                          final task = DummyTaskData().dummyTasks[index];
                          if (task.isShared) {
                            return TaskCard(task: task, heigth: screenHeight);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
