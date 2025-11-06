import 'package:flutter/material.dart';
import 'package:unimarket/domain/models/products/product.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';
import 'package:unimarket/utils/generic_snackbar.dart';

class ProductCardView extends StatelessWidget {
  final Product product;
  final ShoppingCartViewModel viewModel;

  const ProductCardView({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Container(
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0C36B), width: 1.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _truncateText(product.name, 10),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              product.rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Color(0xFFFFC107),
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    const Text(
                      'Car Burguer',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),

                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price.toInt()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFC107),
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            onTap: () {
                              if(viewModel.addToCart(product)) {
                                genericSnackbar(context, 'Se añadio el producto al carrito de compras', Colors.blue, Colors.white);
                                return;
                              }

                              genericSnackbar(context, 'Ya cuentas con este producto en tu carrito', Colors.orangeAccent, Colors.white);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
