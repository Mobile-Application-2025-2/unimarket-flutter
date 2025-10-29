import 'package:flutter/material.dart';

class AccountTypeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const AccountTypeDropdown({
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
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          hintText: 'Select Account Type',
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(Icons.person_outline, color: Color(0xFFFFC436), size: 20),
        ),
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
        items: const [
          DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
          DropdownMenuItem(value: 'business', child: Text('Business')),
        ],
        onChanged: enabled ? (v) { if (v != null) onChanged(v); } : null,
      ),
    );
  }
}

