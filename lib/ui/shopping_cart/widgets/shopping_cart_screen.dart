import 'package:flutter/material.dart';
import 'package:unimarket/ui/shopping_cart/widgets/cart_item_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/header_view.dart';
import 'package:unimarket/ui/shopping_cart/widgets/payment_section_view.dart';
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
                    SizedBox(height: 24),
                    PaymentSection(),
                    SizedBox(height: 16),
                    TotalSection(),
                    SizedBox(height: 24),
                    SizedBox(
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
                        onPressed: () {},
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
