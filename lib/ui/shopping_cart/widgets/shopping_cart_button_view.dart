import 'package:flutter/material.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';
import 'package:unimarket/utils/generic_snackbar.dart';
import 'package:go_router/go_router.dart';

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
        onPressed: () async {
          if (!(await viewModel.makeOrders())) {
            genericSnackbar(context, "Tienes que agregar productos a tu carrito.", Colors.orange, Colors.white);
            return;
          };
          genericSnackbar(context, "Se creo correctamente la orden.", Colors.green, Colors.white);
          context.pop();
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
