import 'package:flutter/material.dart';
import 'package:unimarket/utils/snackbar.dart';

class UnimarketHeader extends StatelessWidget {
  const UnimarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.asset('assets/images/sign.png', width: 30,),
          const SizedBox(width: 8),

          // Title
          const Text(
            'Explorar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),

          const Spacer(),

          // Icons
          Row(
            children: [
              IconButton(
                onPressed: () => showInfoSnackbar(context),
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => showInfoSnackbar(context),
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
