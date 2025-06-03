import 'package:flutter/material.dart';
import 'package:habitsync/core/color/strings.dart';
import 'package:habitsync/core/utils/constants.dart';

class HS_AppBar extends StatelessWidget {
  const HS_AppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.greet,
                  style: TextStyle(fontSize: AppTextSizes.bodyLarge),
                ),
                Text(
                  AppStrings.username,
                  style: TextStyle(fontSize: AppTextSizes.bodyLarge),
                )
              ],
            )
          ],
        ),
        Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          weight: 0.1,
          size: 35,
        )
      ],
    );
  }
}
