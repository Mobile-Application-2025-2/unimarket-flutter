import 'package:flutter/material.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';

class TotalSection extends StatelessWidget {
  const TotalSection({super.key, required this.viewModel});

  final ShoppingCartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            '\$${viewModel.total}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
