import 'package:flutter/material.dart';

import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/core/ui/unimarket_header.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/categories_horizontal_scroll_view.dart';
import 'package:unimarket/ui/core/ui/error_indicator.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/business_vertical_scroll_view.dart';

class HomePageBuyerScreen extends StatelessWidget {
  const HomePageBuyerScreen({super.key, required this.viewModel});

  final HomePageBuyerViewModel viewModel;

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
                const UnimarketHeader(title: 'UniMarket'),

                CategoriesHorizontalScrollView(viewModel: viewModel),
                const SizedBox(height: 16),

                BusinessesVerticalScrollView(viewModel: viewModel),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}
