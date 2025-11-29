import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderCart extends StatelessWidget {
  const HeaderCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2F5F9),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1B1E),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
