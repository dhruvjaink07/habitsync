import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final bool isDark;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.isDark,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final Gradient backgroundGradient = widget.isDark
        ? AppColors.darkBackgroundGradient
        : AppColors.lightBackgroundGradient;

    return GlassMorphism(
      borderRadius: 0,
      start: 0.3,
      end: 0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.isDark
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.secondary.withOpacity(0.15),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isDark ? AppColors.primary : AppColors.secondary)
                  .withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home_outlined,
                  size: AppTextSizes.iconLarge,
                  color: widget.selectedIndex == 0
                      ? (widget.isDark
                          ? AppColors.primary
                          : AppColors.secondary)
                      : (widget.isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight)),
              onPressed: () => widget.onTap(0),
            ),
            IconButton(
              icon: Icon(Icons.add,
                  size: AppTextSizes.iconLarge,
                  color: widget.selectedIndex == 1
                      ? (widget.isDark
                          ? AppColors.primary
                          : AppColors.secondary)
                      : (widget.isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight)),
              onPressed: () => widget.onTap(1),
            ),
            IconButton(
              icon: Icon(Icons.bar_chart_outlined,
                  size: AppTextSizes.iconLarge,
                  color: widget.selectedIndex == 2
                      ? (widget.isDark
                          ? AppColors.primary
                          : AppColors.secondary)
                      : (widget.isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight)),
              onPressed: () => widget.onTap(2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  size: AppTextSizes.iconLarge,
                  color: widget.selectedIndex == 3
                      ? (widget.isDark
                          ? AppColors.primary
                          : AppColors.secondary)
                      : (widget.isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight)),
              onPressed: () => widget.onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
