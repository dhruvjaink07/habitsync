import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.isDark,
    this.onPressed,
  });

  final bool isDark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.white.withOpacity(0.85),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: onPressed ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Google Sign-In is not implemented yet."),
                backgroundColor: isDark
                    ? AppColors.warning
                    : AppColors.warning.withOpacity(0.8),
              ),
            );
          },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/images/google_sign_in.png"),
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 10),
          Text(
            "Continue with Google",
            style: TextStyle(
              fontSize: 17,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
