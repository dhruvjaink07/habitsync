import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';

class OverlappingAvatars extends StatelessWidget {
  final int count;
  final double radius;
  final List<Color> colors;

  const OverlappingAvatars({
    super.key,
    this.count = 3,
    this.radius = 22,
    this.colors = const [
      AppColors.cardDark,
      AppColors.darkSecondary,
      AppColors.workoutColor,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2 +
          (count - 1) * radius * 1.1, // ensure enough width for overlap
      height: radius * 2,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * (radius * 1.1),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: colors[index % colors.length],
              child: Icon(Icons.person, color: Colors.white, size: radius),
            ),
          );
        }),
      ),
    );
  }
}
