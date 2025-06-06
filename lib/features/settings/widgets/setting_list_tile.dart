import 'package:flutter/material.dart';

// --- List Tile Section ---
class SettingsListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsListTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leadingIcon != null
          ? Icon(leadingIcon, color: Colors.grey[700])
          : null,
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
