import 'package:flutter/material.dart';

/// Dropdown for selecting business category
class BusinessCategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  static const List<String> categories = [
    'accesorios',
    'comidas',
    'papeleria',
    'tutorias',
  ];

  const BusinessCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: (value?.isEmpty ?? true) ? null : value,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          hintText: 'Select Category',
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
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
        items: categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category[0].toUpperCase() + category.substring(1),
            ),
          );
        }).toList(),
      ),
    );
  }
}

