import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnimarketNavigationBar extends StatelessWidget {
  const UnimarketNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC436),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
          IconButton(
            onPressed: () => context.go('/home_buyer'),
            icon: const Icon(
              Icons.add_business_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          IconButton(
            onPressed: () => context.go('/home_page_buyer'),
            icon: const Icon(Icons.search, color: Colors.white, size: 24),
          ),

          /*Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),*/

          // Cart
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag, color: Colors.white, size: 24),
          ),

          // Profile
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
