import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';

class FriendProfileScreen extends StatelessWidget {
  final User friend;
  const FriendProfileScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Back button and spacing
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: textColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundImage: CachedNetworkImageProvider(
                friend.avatar.isNotEmpty
                    ? friend.avatar
                    : 'https://i.pravatar.cc/150?img=3',
              ),
              backgroundColor: cardColor,
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              friend.name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            // Username
            Text(
              '@${friend.username}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Bio
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                friend.bio ?? 'Habit Master',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Streak & Check-ins
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Current Streak',
                  value: friend.streak?.toString() ?? '0',
                  color1: Colors.blueAccent,
                  color2: Colors.purpleAccent,
                ),
                const SizedBox(width: 16),
                const _StatCard(
                  icon: Icons.check_circle,
                  label: 'Weekly Check-ins',
                  value: 'N/A',
                  color1: Colors.pinkAccent,
                  color2: Colors.purpleAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // You can add more friend info or actions here
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color1;
  final Color color2;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
