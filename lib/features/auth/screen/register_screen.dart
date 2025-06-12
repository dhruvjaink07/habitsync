import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/core/utils/constants.dart';
import 'package:habitsync/features/auth/controller/auth_controller.dart';
import 'package:habitsync/features/auth/screen/login_screen.dart';
import 'package:habitsync/features/auth/widgets/button_divider.dart';
import 'package:habitsync/features/auth/widgets/google_sign_in_button.dart';
import 'package:habitsync/features/auth/widgets/submit_button.dart';
import 'package:habitsync/features/auth/widgets/secure_text_fields.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/features/onboarding/screens/on_boarding_screen.dart';
import 'package:habitsync/services/app_preferences.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _avatarImage;
  int _step = 0;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarImage = File(picked.path);
      });
    }
  }

  void handleNextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _step = 1;
      });
    }
  }

  void handleRegister() {
    if (_bioController.text.trim().isEmpty) {
      EasyLoading.showError("Bio cannot be empty");
      return;
    }
    ref.read(authControllerProvider.notifier).register(
          _usernameController.text.trim(),
          _nameController.text.trim(),
          _emailController.text.trim(),
          _bioController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(authControllerProvider, (prev, next) async {
      if (next is AsyncLoading) {
        EasyLoading.show(status: 'Creating account...');
      } else {
        EasyLoading.dismiss();
      }

      if (next is AsyncData && next.value != null) {
        await AppPreferences.setAuthenticated(true);

        final hasSeenOnboarding = await AppPreferences.isOnboardingComplete();
        final route =
            hasSeenOnboarding ? const MainScreen() : const OnBoardingScreen();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => route),
          (route) => false,
        );
      } else if (next is AsyncError) {
        EasyLoading.showError(next.error.toString());
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
              child: _step == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      AppColors.secondary,
                                      AppColors.darkSecondary
                                    ]
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
                                size: 24, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Sign up to get started",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SecureFields(
                          controller: _usernameController,
                          isDark: isDark,
                          hintText: "Enter username",
                          icon: Icons.alternate_email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Username cannot be empty";
                            }
                            if (value.contains(' ')) {
                              return "Username cannot contain spaces";
                            }
                            if (value.trim().length < 3) {
                              return "Username must be at least 3 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        SecureFields(
                          controller: _nameController,
                          isDark: isDark,
                          hintText: "Enter name",
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Name cannot be empty";
                            }
                            if (value.trim().length < 3) {
                              return "Name must be at least 3 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
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
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
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
                        const SizedBox(height: 18),
                        SecureFields(
                          controller: _confirmPasswordController,
                          isDark: isDark,
                          hintText: "Confirm your password",
                          icon: Icons.password_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Next Button
                        SubmitButton(
                          isDark: isDark,
                          text: "Next",
                          onPressed: handleNextStep,
                        ),
                        const SizedBox(height: 18),
                        ButtonDivider(isDark: isDark),
                        const SizedBox(height: 18),
                        GoogleSignInButton(isDark: isDark),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                          child: Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.secondary
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 60,
                          color:
                              isDark ? AppColors.secondary : AppColors.primary,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Tell us about yourself",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Write a short bio to let others know more about you.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _bioController,
                          maxLines: 4,
                          maxLength: 120,
                          decoration: InputDecoration(
                            hintText:
                                "E.g. I love building habits and exploring new things!",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white10
                                : Colors.grey.withOpacity(0.08),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Bio cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SubmitButton(
                          isDark: isDark,
                          text: "Register",
                          onPressed: handleRegister,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _step = 0;
                            });
                          },
                          child: Text("Back"),
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
