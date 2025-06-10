import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// --- Profile Section ---
class ProfileSection extends StatelessWidget {
  const ProfileSection(
      {super.key, required this.url, required this.name, required this.email});
  final String url;
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: CachedNetworkImageProvider(url),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
