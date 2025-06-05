import 'package:flutter/material.dart';
import 'package:habitsync/core/theme/theme.dart';
import 'package:habitsync/features/auth/screen/login_screen.dart';
import 'package:habitsync/features/auth/screen/register_screen.dart';
import 'package:habitsync/features/main/main_screen.dart';

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
      home: const RegisterScreen(),
    );
  }
}
