import 'package:flutter/material.dart';

import 'package:unimarket/ui/core/ui/generic_search_bar.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/core/ui/unimarket_header.dart';
import 'package:unimarket/ui/home_buyer/widgets/categories_horizontal_scroll_view.dart';
import 'package:unimarket/ui/home_buyer/widgets/subcategories_vertical_scroll_view.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';

class HomeBuyerScreen extends StatelessWidget {
  const HomeBuyerScreen({super.key, required this.viewModel});

  final HomeBuyerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            /*
            if (viewModel.load.running) { return const Center(child: CircularProgressIndicator()); }
            if (viewModel.load.error) { return ErrorIndicator(title: "Error cargando", label: "Intengar otra vez", onPressed: viewModel.load.execute ); }
            */

            return Column(
              children: [
                const UnimarketHeader(),

                GenericSearchBar(onChanged: viewModel.setSearchQuery),
                const SizedBox(height: 16),

                // CategoriesHorizontalScrollView(viewModel: viewModel),
                // const SizedBox(height: 16),

                SubcategoriesVerticalScrollView(viewModel: viewModel),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}
