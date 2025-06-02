import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/home/widgets/overlapping_avatars.dart';
import 'package:habitsync/models/task_model.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  double heigth;

  TaskCard({super.key, required this.task, required this.heigth});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassMorphism(
          start: 0.3,
          end: 0.2,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: task.isShared ? heigth * 0.18 : heigth * 0.12,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title ?? ''),
                        Text(task.description ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: AppColors.workoutColor,
                        ),
                        Text((task.streakCount ?? '').toString())
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(24),
                  value: (task.streakCount ?? 0) * 0.10,
                  backgroundColor: AppColors.progressBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.readingColor),
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: task.isShared,
                  child: const Align(
                      alignment: Alignment.centerRight,
                      child: OverlappingAvatars()),
                )
              ],
            ),
          )),
    );
  }
}
