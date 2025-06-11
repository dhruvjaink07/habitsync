import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/auth/controller/auth_controller.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/onboarding/screens/splash_screen.dart';
import 'package:habitsync/features/profile/controller/profile_controller.dart';
import 'package:habitsync/features/settings/widgets/delete_section.dart';
import 'package:habitsync/features/settings/widgets/profile_section.dart';
import 'package:habitsync/features/settings/widgets/setting_list_tile.dart';
import 'package:habitsync/features/settings/widgets/switch_section.dart';
import 'package:habitsync/services/profile_cache_service.dart';

// --- Main Settings Screen ---
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool habitReminders = true;
  bool friendActivity = false;
  User? _user;
  Future<void> _loadProfile() async {
    final User? user = await ProfileCacheService.getCachedUserProfile();
    setState(() {
      _user = user;
    });
  }

  Future<void> _deleteAccount() async {
    ref.read(profileControllerProvider.notifier).deleteProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.of(context).pop(true);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          ProfileSection(
              url: _user?.avatar ?? 'https://i.pravatar.cc/150?img=3',
              name: _user?.name ?? 'John Doe',
              email: _user?.email ?? 'john@doe.com'),
          const SizedBox(height: 32),
          SettingsSwitchTile(
            icon: Icons.notifications,
            title: 'Habit Reminders',
            subtitle: 'Daily notifications',
            value: habitReminders,
            onChanged: (val) => setState(() => habitReminders = val),
            activeColor: AppColors.primary,
          ),
          SettingsSwitchTile(
            icon: Icons.notifications,
            title: 'Friend Activity',
            subtitle: 'When friends complete habits',
            value: friendActivity,
            onChanged: (val) => setState(() => friendActivity = val),
            activeColor: AppColors.primary,
          ),
          const Divider(height: 32),
          SettingsListTile(
            leadingIcon: Icons.lock,
            title: 'Clear Local Data',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Add clear local data logic
            },
          ),
          SettingsListTile(
            leadingIcon: Icons.vpn_key,
            title: 'Change Password',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Add change password logic
            },
          ),
          const Divider(height: 32),
          const SettingsListTile(
            leadingIcon: Icons.info_outline,
            title: 'Version 0.0.1',
          ),
          SettingsListTile(
            title: 'Terms of Service',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open Terms of Service
            },
          ),
          SettingsListTile(
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open Privacy Policy
            },
          ),
          SettingsListTile(
            title: 'Contact Support',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open Contact Support
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (route) => false);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          DeleteAccountSection(
            onDelete: () => _confirmDeleteAccount(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
