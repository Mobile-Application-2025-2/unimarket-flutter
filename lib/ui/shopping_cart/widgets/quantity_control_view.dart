import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFFFFF8E1),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(width: 8),
          Icon(Icons.remove, size: 16, color: Color(0xFFFFC107)),
          SizedBox(width: 8),
          Text(
            '2',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.add, size: 16, color: Color(0xFFFFC107)),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
