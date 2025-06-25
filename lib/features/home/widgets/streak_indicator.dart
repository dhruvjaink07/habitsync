import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';

class StreakIndicator extends StatefulWidget {
  const StreakIndicator({
    super.key,
    required this.screenHeight,
    required this.isDark,
    required this.screenWidth,
    required this.duration, // Duration for the circle to fill
    required this.streakCount,
    this.onComplete,
    this.startOnInit = true,
  });

  final double screenHeight;
  final bool isDark;
  final double screenWidth;
  final Duration duration;
  final int streakCount;
  final VoidCallback? onComplete;
  final bool startOnInit;

  @override
  State<StreakIndicator> createState() => _StreakIndicatorState();
}

class _StreakIndicatorState extends State<StreakIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.startOnInit) {
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Call this method to start or restart the animation from outside
  void start() {
    _controller.forward(from: 0);
  }

  /// Call this method to reset the animation from outside
  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.screenHeight * 0.22;
    return SizedBox(
      height: size,
      width: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _StreakCirclePainter(
              progress: _controller.value,
              isDark: widget.isDark,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: AppColors.progressGreen,
                    size: widget.screenWidth * 0.10,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.streakCount}',
                    style: TextStyle(
                      fontSize: AppTextSizes.headingLarge,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? AppColors.headingDark
                          : AppColors.headingLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Day Streak',
                    style: TextStyle(
                      fontSize: AppTextSizes.bodyMedium,
                      color: widget.isDark
                          ? AppColors.subtextDark
                          : AppColors.subtextLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StreakCirclePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final bool isDark;

  _StreakCirclePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width / 2) - strokeWidth / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark
          ? AppColors.secondary.withOpacity(0.08)
          : AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    // Foreground progress arc
    final fgPaint = Paint()
      ..color = AppColors.progressGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    const startAngle = -90 * 3.1415926535 / 180; // Start at top
    final sweepAngle = 2 * 3.1415926535 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_StreakCirclePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
