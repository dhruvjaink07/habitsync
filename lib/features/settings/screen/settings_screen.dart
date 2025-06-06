import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/settings/widgets/delete_section.dart';
import 'package:habitsync/features/settings/widgets/profile_section.dart';
import 'package:habitsync/features/settings/widgets/setting_list_tile.dart';
import 'package:habitsync/features/settings/widgets/switch_section.dart';

// --- Main Settings Screen ---
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool habitReminders = true;
  bool friendActivity = false;

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // TODO: Add your delete account logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted.'),
          backgroundColor: Colors.red,
        ),
      );
      // Optionally navigate away or log out
    }
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
          const ProfileSection(),
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
              onPressed: () {
                // Add logout logic
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
