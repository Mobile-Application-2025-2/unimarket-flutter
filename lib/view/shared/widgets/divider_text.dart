import 'package:flutter/material.dart';

class DividerText extends StatelessWidget {
  final String text;
  final Color textColor;
  
  const DividerText({
    super.key,
    required this.text,
    this.textColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: textColor,
        fontFamily: 'Poppins',
      ),
    );
  }
}
