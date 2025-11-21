import 'package:flutter/material.dart';

/// Custom painter for drawing a wave-shaped yellow background
class WaveBackgroundPainter extends CustomPainter {
  final Color color;

  const WaveBackgroundPainter({this.color = const Color(0xFFECAB0F)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..lineTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.25, size.height * 0.5,
        size.width * 0.4, size.height * 0.45,
      )
      ..quadraticBezierTo(
        size.width * 0.65, size.height * 0.3,
        size.width, size.height * 0.5,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

