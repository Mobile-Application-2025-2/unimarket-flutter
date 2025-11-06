import 'package:flutter/material.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/repositories/products/product_repository_firestore.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';
import 'package:unimarket/ui/shopping_cart/widgets/cart_item_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/header_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/payment_section_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/shopping_cart_button_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/total_section_view.dart';

class ShoppingCartScreen extends StatelessWidget {
  final ShoppingCartViewModel viewModel;

  const ShoppingCartScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(listenable: viewModel, builder: (context, child) {
          return Column(
            children: [
              HeaderCart(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...viewModel.cartItems.map((product) => CartItem(product: product, viewModel: viewModel)),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 20, top: 10),
                  child: Column(
                      children: [
                        PaymentSection(),
                        SizedBox(height: 16),
                        TotalSection(viewModel: viewModel),
                        SizedBox(height: 24),
                        ShoppingCartButtonView(),
                      ]
                  )
              )
            ],
          );
        }),
      )
    );
  }
}
