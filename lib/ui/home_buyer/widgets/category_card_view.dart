import 'package:flutter/material.dart';
import 'package:unimarket/domain/models/categories/category.dart';
import 'package:unimarket/utils/generic_snackbar.dart';

class CategoryCardView extends StatelessWidget {
  const CategoryCardView({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => genericSnackbar(context, 'El detalle de la categoria no se encuentra disponible.', Colors.yellow, Colors.black),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFF72),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.add_call,
                        size: 40,
                        color: Colors.grey[600],
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC436)),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _truncateText(category.name, 20),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.selectionCount} selecciones',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
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

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
