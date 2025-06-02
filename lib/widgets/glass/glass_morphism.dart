import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final double borderRadius;

  const GlassMorphism({
    super.key,
    required this.child,
    required this.start,
    required this.end,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(start),
                  Colors.white.withOpacity(end),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              )),
          child: child,
        ),
      ),
    );
  }
}
