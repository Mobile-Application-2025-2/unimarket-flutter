import 'package:flutter/material.dart';

class GenericSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const GenericSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          onChanged: onChanged,
          maxLength: 25,
          decoration: InputDecoration(
            hintText: 'Buscar en UniMarket',
            counterText: '',
            // suffixText: '25',
            // suffixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}
