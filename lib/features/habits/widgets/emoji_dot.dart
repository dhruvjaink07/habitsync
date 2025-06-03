import 'package:flutter/material.dart';

class EmojiDot extends StatelessWidget {
  final String emoji;
  final bool selected;
  const EmojiDot(this.emoji, {super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: selected ? Border.all(color: Colors.white, width: 3) : null,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 18)),
    );
  }
}
