import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/home/widgets/overlapping_avatars.dart';
import 'package:habitsync/models/task_model.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  double heigth;

  TaskCard({super.key, required this.task, required this.heigth});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool isCompleted = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
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
        SnackBar(content: Text('${widget.task.title} marked as completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
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
                height: widget.task.isShared
                    ? widget.heigth * 0.18
                    : widget.heigth * 0.16,
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
                            Text(widget.task.title ?? ''),
                            Text(widget.task.description ?? ''),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: AppColors.workoutColor,
                            ),
                            Text((widget.task.streakCount ?? '').toString())
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(24),
                      value: (widget.task.streakCount ?? 0) * 0.10,
                      backgroundColor: AppColors.progressBackground,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.readingColor),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: widget.task.isShared,
                      child: const Align(
                          alignment: Alignment.centerRight,
                          child: OverlappingAvatars()),
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
