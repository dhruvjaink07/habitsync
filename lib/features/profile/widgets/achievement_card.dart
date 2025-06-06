import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class AchievementData {
  final String title;
  final IconData icon;
  final bool achieved;
  AchievementData(this.title, this.icon, this.achieved);
}

class AchievementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool achieved;

  const AchievementCard({
    super.key,
    required this.title,
    required this.icon,
    required this.achieved,
  });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _AchievementDialog(
        title: title,
        icon: icon,
        achieved: achieved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final accent =
        achieved ? theme.colorScheme.secondary : cardColor.withOpacity(0.7);
    final iconColor = achieved ? Colors.white : Colors.white38;
    final textColor = achieved ? Colors.white : Colors.white38;

    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: achieved ? accent : cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool achieved;

  const _AchievementDialog({
    required this.title,
    required this.icon,
    required this.achieved,
  });

  @override
  State<_AchievementDialog> createState() => _AchievementDialogState();
}

class _AchievementDialogState extends State<_AchievementDialog> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.achieved) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: AchievementCard(
            title: widget.title,
            icon: widget.icon,
            achieved: widget.achieved,
          ),
        ),
        if (widget.achieved)
          ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.2,
          ),
      ],
    );
  }
}
