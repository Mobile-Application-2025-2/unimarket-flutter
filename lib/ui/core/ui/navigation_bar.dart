import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

class UnimarketNavigationBar extends StatelessWidget {
  const UnimarketNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.toString();

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
          IconButton(
            onPressed: () => context.go(Routes.homePageBuyer),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Routes.homePageBuyer == currentRoute
                    ? Colors.white.withOpacity(0.2)
                    : Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_business_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          IconButton(
            onPressed: () => context.go(Routes.homeBuyer),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Routes.homeBuyer == currentRoute
                    ? Colors.white.withOpacity(0.2)
                    : Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),

          IconButton(
            onPressed: () => context.go(Routes.map),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Routes.map == currentRoute
                    ? Colors.white.withOpacity(0.2)
                    : Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.map_outlined, color: Colors.white, size: 24),
            ),
          ),

          IconButton(
            onPressed: () => context.go(Routes.profileBuyer),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Routes.profileBuyer == currentRoute
                    ? Colors.white.withOpacity(0.2)
                    : Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}