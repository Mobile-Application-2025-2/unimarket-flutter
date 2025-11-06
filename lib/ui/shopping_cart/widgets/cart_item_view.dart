import 'package:flutter/material.dart';
import 'package:unimarket/domain/models/products/product.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.product, required this.viewModel});

  final Product product;
  final ShoppingCartViewModel viewModel;

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
              product.image,
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
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.close, size: 20),
                      onTap: () {
                        print("CART ITEM: Remove item");
                        viewModel.removeFromCart(product);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${product.price.toInt()}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFFFF8E1),
                    border: Border.all(color: const Color(0xFFFFC107)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 8),
                      GestureDetector(
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Color(0xFFFFC107),
                        ),
                        onTap: () {
                          viewModel.changeProductUnit("DECREASE", product);
                        },
                      ),
                      SizedBox(width: 8),
                      Text(
                        viewModel.getCounts(product.id).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Color(0xFFFFC107),
                        ),
                        onTap: () {
                          viewModel.changeProductUnit("INCREASE", product);
                        },
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
