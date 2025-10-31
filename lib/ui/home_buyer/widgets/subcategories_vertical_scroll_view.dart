import 'package:flutter/material.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
import 'package:unimarket/ui/home_buyer/widgets/product_card_view.dart';
import 'package:unimarket/utils/generic_snackbar.dart';


class SubcategoriesVerticalScrollView extends StatelessWidget {
  final HomeBuyerViewModel viewModel;

  const SubcategoriesVerticalScrollView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.filteredCategories.isEmpty) {
      return const Expanded(child: Center(child: Text("No hay productos para mostrar.", style: TextStyle(fontSize: 16),)));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: viewModel.filteredCategories.length,
          itemBuilder: (context, index) {
            final category = viewModel.filteredCategories[index];
            return GestureDetector(
                child: ProductCardView(product: category),
                onTap: () => genericSnackbar(context, 'El detalle del producto no se encuentra disponible.', Colors.yellow, Colors.black),
            );
          },
        ),
      ),
    );
  }
}
