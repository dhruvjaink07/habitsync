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
    final Color bgColor = widget.isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.7);

    final List<IconData> icons = [
      Icons.home_outlined,
      Icons.add,
      Icons.bar_chart_outlined,
      Icons.person_outline,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: (widget.isDark ? AppColors.primary : AppColors.secondary)
                    .withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final bool isSelected = widget.selectedIndex == index;
              final Color activeColor =
                  widget.isDark ? AppColors.primary : AppColors.secondary;
              final Color inactiveColor = widget.isDark
                  ? AppColors.subtextDark
                  : AppColors.subtextLight;

              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      width: isSelected ? 48 : 40,
                      height: isSelected ? 48 : 40,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: activeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            )
                          : null,
                      child: Icon(
                        icons[index],
                        size: isSelected
                            ? AppTextSizes.iconLarge + 4
                            : AppTextSizes.iconLarge,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
