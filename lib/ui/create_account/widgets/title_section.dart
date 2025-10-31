import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final Color titleColor;
  
  const TitleSection({
    super.key,
    required this.title,
    this.titleColor = const Color(0xFFFFC436),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorative background shapes
        Positioned(
          top: -20,
          left: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: titleColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: -30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF7D547).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Title text
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: titleColor,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
