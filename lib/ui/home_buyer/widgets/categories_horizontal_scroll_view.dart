import 'package:flutter/material.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';

class CategoriesHorizontalScrollView extends StatelessWidget {
  final HomeBuyerViewModel viewModel;

  const CategoriesHorizontalScrollView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: viewModel.uniqueCategories.length,
          itemBuilder: (context, index) {
            final categoryType = viewModel.uniqueCategories[index];
            final isSelected = categoryType == viewModel.selectedCategory;

            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () => viewModel.setSelectedCategory(categoryType),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFC436) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFFC436) : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        "${categoryType[0].toUpperCase()}${categoryType.substring(1).toLowerCase()}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}
