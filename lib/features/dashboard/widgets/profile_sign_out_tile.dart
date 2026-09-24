import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Styled Sign Out list tile for profile drawer.
class ProfileSignOutTile extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileSignOutTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(
        Icons.logout_rounded,
        color: AppColors.dangerRed,
        size: 20,
      ),
      title: const Text(
        'Sign Out',
        style: TextStyle(
          color: AppColors.dangerRed,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
