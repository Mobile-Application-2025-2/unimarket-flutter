import 'package:flutter/material.dart';

import 'package:unimarket/ui/core/ui/generic_search_bar.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/core/ui/unimarket_header.dart';
import 'package:unimarket/ui/home_buyer/widgets/subcategories_vertical_scroll_view.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';

class HomeBuyerScreen extends StatelessWidget {
  const HomeBuyerScreen({super.key, required this.viewModel, required this.shoppingCartViewModel});

  final ShoppingCartViewModel shoppingCartViewModel;
  final HomeBuyerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return Column(
              children: [
                const UnimarketHeader(title: 'Explorar'),

                GenericSearchBar(onChanged: viewModel.setSearchQuery),
                const SizedBox(height: 16),

                SubcategoriesVerticalScrollView(viewModel: viewModel, shoppingCartViewModel: shoppingCartViewModel),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}
