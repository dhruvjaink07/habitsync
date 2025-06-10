import 'package:flutter/material.dart';

class SecureFields extends StatelessWidget {
  const SecureFields(
      {super.key,
      required this.controller,
      required this.isDark,
      required this.hintText,
      required this.icon,
      required this.validator,
      this.isPassword = false,
      this.keyboardType = TextInputType.text});

  final bool isDark;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isPassword,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.white,
      ),
    );
  }
}
