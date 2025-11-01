import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onAvatarTap,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFFFFD1B9),
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? NetworkImage(avatarUrl!)
                : null,
            child: (avatarUrl == null || avatarUrl!.isEmpty)
                ? Icon(
                    Icons.person_outline,
                    size: radius,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

