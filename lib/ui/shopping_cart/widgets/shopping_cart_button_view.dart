import 'package:flutter/material.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';

class ShoppingCartButtonView extends StatelessWidget {
  final ShoppingCartViewModel viewModel;

  const ShoppingCartButtonView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          viewModel.makeOrders();
        },
        child: Text(
          'PEDIR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
