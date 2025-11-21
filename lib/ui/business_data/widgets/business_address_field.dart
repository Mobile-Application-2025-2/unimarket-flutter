import 'package:flutter/material.dart';

/// Text field for business address input
class BusinessAddressField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const BusinessAddressField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      enabled: enabled,
      maxLength: 120,
      maxLines: 2,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Business Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins',
        ),
        counterText: '',
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black87,
      ),
    );
  }
}

