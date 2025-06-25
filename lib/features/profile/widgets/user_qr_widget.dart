import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Usage: Pass the user's id as userId
class UserQrCodeWidget extends StatelessWidget {
  final String username;
  const UserQrCodeWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: username,
      version: QrVersions.auto,
      size: 180.0,
      backgroundColor: Colors.white,
    );
  }
}
