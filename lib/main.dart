import 'package:flutter/material.dart';
import 'package:habitsync/core/theme/theme.dart';
import 'package:habitsync/features/onboarding/screens/on_boarding_screen.dart';
import 'package:habitsync/features/onboarding/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen());
  }
}
