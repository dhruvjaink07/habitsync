import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/auth/screen/login_screen.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/features/onboarding/screens/on_boarding_screen.dart';
import 'package:habitsync/services/app_preferences.dart';
import 'package:habitsync/services/profile_cache_service.dart';
import 'package:habitsync/widgets/glass/glass_morphism.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _checkAndNavigate);
  }

  Future<void> _checkAndNavigate() async {
    final isLoggedIn = await AppPreferences.isAuthenticated();
    final cachedProfile = await ProfileCacheService.getCachedUserProfile();
    final seenOnboarding = await AppPreferences.isOnboardingComplete();

    Widget nextScreen;

    if (isLoggedIn && cachedProfile != null) {
      nextScreen =
          seenOnboarding ? const MainScreen() : const OnBoardingScreen();
    } else {
      nextScreen = const LoginScreen();
    }

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    }
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
              : AppColors.lightBackgroundGradient,
        ),
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
                    child: Text(
                      "HS",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
