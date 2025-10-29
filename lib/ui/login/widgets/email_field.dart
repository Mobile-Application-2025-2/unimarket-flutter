import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const EmailField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        onChanged: enabled ? onChanged : null,
        keyboardType: TextInputType.emailAddress,
        enabled: enabled,
        decoration: const InputDecoration(
          hintText: 'Email address',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
        ),
      ),
    );
  }
}

