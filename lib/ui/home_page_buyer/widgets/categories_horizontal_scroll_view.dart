import 'package:flutter/material.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoriesHorizontalScrollView extends StatelessWidget {
  final HomePageBuyerViewModel viewModel;

  const CategoriesHorizontalScrollView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: viewModel.uniqueBusinessCategories.length,
        itemBuilder: (context, index) {
          if (viewModel.load.running) {
            return ShimmerTagWidget();
          }

          final categoryType = viewModel.uniqueBusinessCategories[index];
          final isSelected = categoryType == viewModel.selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => viewModel.setSelectedCategory(categoryType),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFC436) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFFC436)
                        : Colors.grey[300]!,
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

class ShimmerTagWidget extends StatelessWidget {
  const ShimmerTagWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          interval: const Duration(milliseconds: 500),
          duration: const Duration(seconds: 1),
          color: Colors.blueGrey,
          colorOpacity: 0.3,
          child: Container(
            width: 100,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
