import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/features/onboarding/screens/on_boarding_screen.dart';
import 'package:habitsync/services/app_preferences.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.isDark,
    required this.text,
    required GlobalKey<FormState> formKey,
    this.onPressed,
  }) : _formKey = formKey;

  final bool isDark;
  final String text;
  final GlobalKey<FormState> _formKey;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    Future<void> checkOnBoardingStatus() async {
      if (await AppPreferences.isOnboardingComplete()) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? AppColors.secondary : AppColors.primary,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: onPressed ??
          () async {
            if (_formKey.currentState?.validate() ?? false) {
              await AppPreferences.setAuthenticated(true);
              await checkOnBoardingStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(text == "Register"
                      ? "User Authenticated Successfully!"
                      : "User Logged In Successfully!"),
                  backgroundColor: isDark
                      ? AppColors.success
                      : AppColors.success.withOpacity(0.8),
                ),
              );
              // Navigate to main screen or perform registration logic here
            }
          },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
