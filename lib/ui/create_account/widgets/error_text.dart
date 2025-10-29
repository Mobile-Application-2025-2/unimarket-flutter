import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String message;

  const ErrorText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

