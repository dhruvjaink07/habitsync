import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';
import 'package:habitsync/features/auth/controller/auth_controller.dart';
import 'package:habitsync/features/auth/screen/register_screen.dart';
import 'package:habitsync/features/auth/widgets/button_divider.dart';
import 'package:habitsync/features/auth/widgets/google_sign_in_button.dart';
import 'package:habitsync/features/auth/widgets/secure_text_fields.dart';
import 'package:habitsync/features/auth/widgets/submit_button.dart';
import 'package:habitsync/features/onboarding/screens/on_boarding_screen.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/services/app_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authControllerProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(authControllerProvider, (prev, next) async {
      if (next is AsyncLoading) {
        EasyLoading.show(status: 'Logging in...');
      } else {
        EasyLoading.dismiss();
      }

      if (next is AsyncData && next.value != null) {
        // if (next is AsyncData) {
        await AppPreferences.setAuthenticated(true);

        final hasSeenOnboarding = await AppPreferences.isOnboardingComplete();
        final route =
            hasSeenOnboarding ? const MainScreen() : const OnBoardingScreen();

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => route),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User authencated successfully")),
        );
      } else if (next is AsyncError) {
        EasyLoading.showError("Login failed: ${next.error}");
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [AppColors.secondary, AppColors.darkSecondary]
                            : [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person_3_outlined,
                          size: 38, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.headingLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : AppColors.subtextLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Email
                  SecureFields(
                    controller: _emailController,
                    isDark: isDark,
                    hintText: "Enter your email",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!AppTextSizes.emailRegex.hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password
                  SecureFields(
                    controller: _passwordController,
                    isDark: isDark,
                    hintText: "Enter your password",
                    icon: Icons.password_outlined,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: isDark
                                ? AppColors.secondary
                                : AppColors.primary.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  SubmitButton(
                    isDark: isDark,
                    text: "Login",
                    onPressed: handleLogin,
                  ),

                  const SizedBox(height: 18),
                  ButtonDivider(isDark: isDark),
                  const SizedBox(height: 18),
                  GoogleSignInButton(isDark: isDark),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.secondary
                            : AppColors.primary.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
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
