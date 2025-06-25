import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FriendQrScannerScreen extends StatefulWidget {
  const FriendQrScannerScreen({super.key});

  @override
  State<FriendQrScannerScreen> createState() => _FriendQrScannerScreenState();
}

class _FriendQrScannerScreenState extends State<FriendQrScannerScreen> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Friend QR'),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.isNotEmpty
              ? barcodeCapture.barcodes.first
              : null;
          if (!_scanned && barcode != null && barcode.rawValue != null) {
            setState(() => _scanned = true);
            Navigator.of(context).pop(barcode.rawValue);
          }
        },
      ),
    );
  }
}

// Example: Custom QR code with logo and colors
class UserQrCodeWidget extends StatelessWidget {
  final String userId;
  const UserQrCodeWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: userId,
      version: QrVersions.auto,
      size: 200.0,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.deepPurple,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Colors.deepPurpleAccent,
      ),
      padding: const EdgeInsets.all(16),
    );
  }
}
