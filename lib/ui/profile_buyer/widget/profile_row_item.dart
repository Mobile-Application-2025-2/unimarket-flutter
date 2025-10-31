import 'package:flutter/material.dart';

class ProfileRowItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileRowItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5DB),
                shape: BoxShape.circle,
              ),
              child: Icon(leadingIcon, color: const Color(0xFFFFC436)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}


