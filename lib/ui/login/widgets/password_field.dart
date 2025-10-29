import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String value;
  final bool visible;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.value,
    required this.visible,
    required this.onChanged,
    required this.onToggleVisibility,
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
        obscureText: !visible,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: enabled ? onToggleVisibility : null,
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

