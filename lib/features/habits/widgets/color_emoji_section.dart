import 'package:flutter/material.dart';
import 'package:habitsync/features/habits/widgets/color_dot.dart';

class ColorEmojiNotesSection extends StatelessWidget {
  final ThemeData theme;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final List<Color> colorOptions;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final TextEditingController notesController;

  const ColorEmojiNotesSection({
    super.key,
    required this.theme,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.colorOptions,
    required this.selectedColor,
    required this.onColorSelected,
    required this.notesController,
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
          Text('Color',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: subTextColor, fontSize: 15)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(colorOptions.length, (i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < colorOptions.length - 1 ? 12 : 0),
                child: GestureDetector(
                  onTap: () => onColorSelected(colorOptions[i]),
                  child: ColorDot(
                    color: colorOptions[i],
                    selected: selectedColor == colorOptions[i],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          Text('Add Notes',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: subTextColor, fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: notesController,
            decoration: InputDecoration(
              hintText: 'Add notes or links...',
              hintStyle: TextStyle(color: subTextColor.withOpacity(0.5)),
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: TextStyle(color: textColor),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
