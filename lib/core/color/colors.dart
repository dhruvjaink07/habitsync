import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Colors
  static const Color primary = Color(0xFF6A5AE0); // Purple-blue
  static const Color secondary = Color(0xFF42A5F5); // Light blue
  static const Color darkPrimary = Color(0xFF1A1A2E);
  static const Color darkSecondary = Color(0xFF2A1B7A);

  // Light Theme Gradient Background
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      secondary,
    ],
  );

  // Dark Theme Gradient Background
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkPrimary, // Deep navy
      darkSecondary, // Purple shadow
    ],
  );

  // Glassmorphism Overlay
  static const Color glassBackground = Colors.white24;
  static const Color glassBorder = Colors.white38;

  // Progress Circle
  static const Color progressGreen = Color(0xFF4CAF50);
  static const Color progressBackground = Color(0xFFB0BEC5);

  // Habit Category Indicators
  static const Color meditationColor = Color(0xFF9C27B0); // Purple
  static const Color readingColor = Color(0xFF2196F3); // Blue
  static const Color workoutColor = Color(0xFFFF5722); // Orange

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // Text Colors
  static const Color headingLight = Colors.black87;
  static const Color subtextLight = Color(0xFF4F4F4F);

  static const Color headingDark = Colors.white;
  static const Color subtextDark = Color(0xFFCCCCCC);

  // Card Colors
  static const Color cardLight = Color(0xFFF3F4F6);
  static const Color cardDark = Color(0xFF1C1E36);

  // Backgrounds
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF0F1123);

  // Icons
  static const Color iconLight = Colors.black;
  static const Color iconDark = Colors.white;

  // Misc
  static const Color divider = Color(0xFFBDBDBD);
  static const Color white = Colors.white;
}
