import 'package:flutter/material.dart';

class PrivacyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const PrivacyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? (v) => onChanged(v ?? false) : null,
          activeColor: const Color(0xFFFFC436),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Poppins'),
              children: [
                TextSpan(text: 'I have read the '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Color(0xFFFFC436), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

