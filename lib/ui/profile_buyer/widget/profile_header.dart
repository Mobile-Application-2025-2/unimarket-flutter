import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String titleText;
  final String userName;
  final Widget? logo;
  final VoidCallback onFavTap;
  final VoidCallback onDeliveriesTap;

  const ProfileHeader({
    super.key,
    required this.titleText,
    required this.userName,
    this.logo,
    required this.onFavTap,
    required this.onDeliveriesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                logo ?? const SizedBox.shrink(),
                const SizedBox(width: 8),
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black87),
                  onPressed: onFavTap,
                ),
                IconButton(
                  icon: const Icon(Icons.local_shipping_outlined, color: Colors.black87),
                  onPressed: onDeliveriesTap,
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFFFD1B9),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}


