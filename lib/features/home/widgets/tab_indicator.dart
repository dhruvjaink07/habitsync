import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/color/strings.dart';

class TabIndicator extends StatelessWidget {
  const TabIndicator({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(32),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isDark ? AppColors.secondary : AppColors.primary,
        ),
        labelColor: AppColors.white,
        unselectedLabelColor:
            isDark ? AppColors.subtextDark : AppColors.subtextLight,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
            text: AppStrings.allStreaks,
          ),
          Tab(text: AppStrings.personal),
          Tab(text: AppStrings.shared),
        ],
      ),
    );
  }
}
