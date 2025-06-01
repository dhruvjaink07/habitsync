import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';

class AppThemes {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F1123);
  static const Color darkCard = Color(0xFF1C1E36);
  static const Color darkText = Colors.white70;

  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightCard = Color(0xFFF3F4F6);
  static const Color lightText = Colors.black87;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: AppColors.primary,
    cardColor: darkCard,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText, fontSize: 16),
      bodyMedium: TextStyle(color: darkText, fontSize: 14),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.progressGreen,
    ),
    dividerColor: AppColors.divider,
    // iconTheme: IconThemeData(color: AppColors.iconColor),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: AppColors.primary,
    cardColor: lightCard,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText, fontSize: 16),
      bodyMedium: TextStyle(color: lightText, fontSize: 14),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.progressGreen,
    ),
    dividerColor: AppColors.divider,
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
