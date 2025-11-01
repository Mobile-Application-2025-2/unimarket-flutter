import 'package:flutter/material.dart';

class ProfileSectionTitleRow extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const ProfileSectionTitleRow({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(leadingIcon, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        if (actionText != null)
          InkWell(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
          )
      ],
    );
  }
}

