import 'package:flutter/material.dart';
import 'package:unimarket/domain/models/products/product.dart';

class ProductCardView extends StatelessWidget {
  final Product product;

  const ProductCardView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0C36B), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con bordes redondeados
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
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
                        color: Color(0xFFE0C36B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
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
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
