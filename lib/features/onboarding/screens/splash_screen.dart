import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/auth/screen/login_screen.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/services/app_preferences.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkLoggedInStatus() async {
    if (await AppPreferences.isAuthenticated()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => _checkLoggedInStatus());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkBackgroundGradient
                : AppColors.lightBackgroundGradient),
        child: Center(
          child: GlassMorphism(
            start: 0.3,
            end: 0.2,
            borderRadius: 15,
            child: Container(
              width: 280,
              height: 320,
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.darkBackgroundGradient
                            : AppColors.lightBackgroundGradient,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("HS",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          )),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'HabitSync',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Build better habits, together',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
