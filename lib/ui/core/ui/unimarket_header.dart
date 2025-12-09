import 'package:flutter/material.dart';
import 'package:unimarket/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';

class UnimarketHeader extends StatelessWidget {
  const UnimarketHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset('assets/images/sign.png', width: 30,),
          const SizedBox(width: 8),

          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),

          const Spacer(),

          Row(
            children: [
              IconButton(
                onPressed: () => notImplementedFunctionalitySnackbar(context),
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => context.push(Routes.shoppingCart),
                icon: const Icon(
                  Icons.local_shipping,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
