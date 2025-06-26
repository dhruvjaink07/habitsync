import 'package:flutter/material.dart';
import 'package:habitsync/core/utils/markHabitCompleteForToday.dart';
import 'package:hive/hive.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/features/home/domain/pending_completion.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final double height;
  final VoidCallback? onTap;
  final VoidCallback? onCompleted;

  const HabitCard({
    super.key,
    required this.habit,
    required this.height,
    this.onTap,
    this.onCompleted, // Add this
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  bool isCompleted = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    isHabitCompletedToday(widget.habit.id).then((completed) {
      setState(() {
        isCompleted = completed;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void markCompleted() async {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
      _controller.forward(from: 0.0);

      // Store in Hive for offline sync
      final pendingBox =
          await Hive.openBox<PendingCompletion>('pendingCompletions');
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final pending = PendingCompletion(
        habitId: widget.habit.id,
        date: today,
        status: "complete",
      );
      await pendingBox.add(pending);

      // Persist completion for today
      await markHabitCompletedForToday(widget.habit.id);

      // Determine streak type
      final streakType =
          widget.habit.sharedWith.isNotEmpty ? 'shared' : 'personal';

      // Check if this is the first completion of this type today
      final completedBox = await Hive.openBox('completedHabits');
      final List completed = completedBox.get(today, defaultValue: <String>[]);

      bool isFirstOfType = false;
      if (streakType == 'personal') {
        // Only count habits with sharedWith.isEmpty
        final personalCompleted = completed.where((id) {
          // You need to check if the habit with this id is personal
          // For now, assume all are personal if you only have personal habits
          // Or, if you have access to all habits, check their sharedWith
          return true;
        }).toList();
        isFirstOfType = personalCompleted.length == 1;
      } else {
        // Only count habits with sharedWith.isNotEmpty
        final sharedCompleted = completed.where((id) {
          // Same as above, check if the habit is shared
          return true;
        }).toList();
        isFirstOfType = sharedCompleted.length == 1;
      }

      if (isFirstOfType) {
        await incrementStreakIfNeeded(streakType: streakType);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.habit.title} marked as completed!')),
      );

      // Call the onCompleted callback if provided
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final color =
        Color(int.parse(widget.habit.color.replaceFirst('#', '0xff')));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        onHorizontalDragEnd: (details) {
          if (!isCompleted &&
              details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            markCompleted();
          }
        },
        child: Stack(
          children: [
            GlassMorphism(
              borderRadius: 10,
              start: 0.3,
              end: 0.2,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: widget.habit.sharedWith.isNotEmpty
                    ? widget.height * 0.18
                    : widget.height * 0.16,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.habit.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isDarkMode ? Colors.white : color)),
                            if (widget.habit.notes.isNotEmpty)
                              Text(widget.habit.notes,
                                  style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.repeat,
                              color: AppColors.readingColor,
                            ),
                            Text(widget.habit.repeatPattern),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(24),
                      value: isCompleted ? 1.0 : 0.0,
                      backgroundColor: AppColors.progressBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: widget.habit.sharedWith.isNotEmpty,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Shared",
                          style: TextStyle(
                              color: AppColors.readingColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: AnimatedScale(
                scale: isCompleted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.progressGreen,
                      radius: 16,
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCompleted ? "Completed" : "",
                      style: const TextStyle(
                        color: AppColors.progressGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isCompleted)
              const Positioned(
                bottom: 12,
                left: 12,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.progressBackground,
                      radius: 16,
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Swipe right to complete",
                      style: TextStyle(
                        color: AppColors.progressBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
