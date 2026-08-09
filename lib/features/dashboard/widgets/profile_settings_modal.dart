import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Modal sheet allowing user to edit profile info & settings.
class ProfileSettingsModal extends StatefulWidget {
  final String userName;
  final ValueChanged<String> onSave;

  const ProfileSettingsModal({
    super.key,
    required this.userName,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String userName,
    required ValueChanged<String> onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProfileSettingsModal(userName: userName, onSave: onSave),
      ),
    );
  }

  @override
  State<ProfileSettingsModal> createState() => _ProfileSettingsModalState();
}

class _ProfileSettingsModalState extends State<ProfileSettingsModal> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0] : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Settings',
                    style: AppTextStyles.headingSmall(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Edit profile details & preferences',
                    style: AppTextStyles.bodySmall(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            style: TextStyle(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'User Name',
              hintText: 'Enter your name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  widget.onSave(newName);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile info updated successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save Profile'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
