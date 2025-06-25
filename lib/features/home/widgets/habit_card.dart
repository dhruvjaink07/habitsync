import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final double height;
  final VoidCallback? onTap; // Add this

  const HabitCard({
    super.key,
    required this.habit,
    required this.height,
    this.onTap,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void markCompleted() {
    if (!isCompleted) {
      setState(() {
        isCompleted = true;
      });
      _controller.forward(from: 0.0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.habit.title} marked as completed!')),
      );
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
        onTap: widget.onTap, // Add this
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
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
