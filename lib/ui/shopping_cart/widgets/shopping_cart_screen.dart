import 'package:flutter/material.dart';
import 'package:unimarket/ui/shopping_cart/widgets/cart_item_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/header_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/payment_section_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/shopping_cart_button_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/total_section_view.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderCart(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartItem(price: "\$64"),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                    CartItem(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10),
              child: Column(
                children: [
                  PaymentSection(),
                  SizedBox(height: 16),
                  TotalSection(),
                  SizedBox(height: 24),
                  ShoppingCartButtonView(),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}
