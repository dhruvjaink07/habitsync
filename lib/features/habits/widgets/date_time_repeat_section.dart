import 'package:flutter/material.dart';
import 'package:habitsync/features/habits/widgets/chip_button.dart';
import 'package:habitsync/features/habits/widgets/section_row.dart';

// Date, Time, Repeat Section
class DateTimeRepeatSection extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final String formattedDate;
  final String formattedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final List<String> repeatOptions;
  final String selectedRepeat;
  final ValueChanged<String> onRepeatSelected;
  final Color primary;
  final ThemeData theme;

  const DateTimeRepeatSection({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.formattedDate,
    required this.formattedTime,
    required this.onPickDate,
    required this.onPickTime,
    required this.repeatOptions,
    required this.selectedRepeat,
    required this.onRepeatSelected,
    required this.primary,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPickDate,
            child: SectionRow(
              icon: Icons.calendar_today_rounded,
              title: 'Start Date',
              value: formattedDate,
              textColor: textColor,
              subTextColor: subTextColor,
              showArrow: true,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPickTime,
            child: SectionRow(
              icon: Icons.access_time_rounded,
              title: 'Time',
              value: formattedTime,
              textColor: textColor,
              subTextColor: subTextColor,
              showArrow: true,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Repeat',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: subTextColor, fontSize: 15),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(repeatOptions.length, (i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < repeatOptions.length - 1 ? 10 : 0),
                child: ChipButton(
                  label: repeatOptions[i],
                  selected: selectedRepeat == repeatOptions[i],
                  color: primary,
                  onTap: () => onRepeatSelected(repeatOptions[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
