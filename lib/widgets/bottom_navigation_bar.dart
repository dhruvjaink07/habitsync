import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';

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
    final List<IconData> icons = [
      Icons.home_outlined,
      Icons.add,
      Icons.bar_chart_outlined,
      Icons.person_outline,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: widget.isDark
              ? Colors.white.withOpacity(0.10)
              : Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            final bool isSelected = widget.selectedIndex == index;
            final Color activeColor =
                widget.isDark ? AppColors.primary : AppColors.secondary;
            final Color inactiveColor =
                widget.isDark ? AppColors.subtextDark : AppColors.subtextLight;

            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      size: AppTextSizes.iconLarge,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(top: 4),
                      height: 3,
                      width: isSelected ? 18 : 0,
                      decoration: BoxDecoration(
                        color: isSelected ? activeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
