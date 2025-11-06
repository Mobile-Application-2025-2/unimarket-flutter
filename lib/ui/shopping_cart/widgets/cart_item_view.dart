import 'package:flutter/material.dart';

import 'package:unimarket/ui/shopping_cart/widgets/quantity_control_view.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, this.price = "\$32"});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/6/62/NCI_Visuals_Food_Hamburger.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Pizza Calzone European',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      child:
                    Icon(Icons.close, size: 20),
                      onTap: () => { print("CART ITEM: Remove item") }
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const QuantityControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
