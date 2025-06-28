import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:habitsync/core/color/strings.dart';
import 'package:habitsync/core/utils/constants.dart';

class HS_AppBar extends StatelessWidget {
  final String url;
  final String username;
  final String greet;
  final VoidCallback? onProfileTap;
  const HS_AppBar(
      {super.key,
      required this.url,
      required this.username,
      required this.greet,
      required this.onProfileTap});
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                onProfileTap!();
              },
              child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                url,
              )),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(fontSize: AppTextSizes.bodyLarge),
                ),
                Text(
                  username,
                  style: const TextStyle(fontSize: AppTextSizes.bodyLarge),
                )
              ],
            )
          ],
        ),
        const Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          weight: 0.1,
          size: 35,
        )
      ],
    );
  }
}
