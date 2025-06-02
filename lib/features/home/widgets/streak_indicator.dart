import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';

class StreakIndicator extends StatelessWidget {
  const StreakIndicator({
    super.key,
    required this.screenHeigt,
    required this.isDark,
    required this.screenWidth,
  });

  final double screenHeigt;
  final bool isDark;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeigt * 0.22, // Reduce size for better appearance
      width: screenHeigt * 0.22, // Make it a perfect circle
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.progressGreen,
          width: 6,
        ),
        color: Colors.transparent, // Transparent background
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.secondary.withOpacity(0.08)
                : AppColors.primary.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department,
              color: AppColors.progressGreen,
              size: screenWidth * 0.10,
            ),
            const SizedBox(height: 8),
            Text(
              '7', // Example streak count
              style: TextStyle(
                fontSize: AppTextSizes.headingLarge,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.headingDark : AppColors.headingLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Day Streak',
              style: TextStyle(
                fontSize: AppTextSizes.bodyMedium,
                color: isDark ? AppColors.subtextDark : AppColors.subtextLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
