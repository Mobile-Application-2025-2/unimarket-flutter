import 'package:flutter/material.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/business_card_view.dart';
import 'package:unimarket/utils/generic_snackbar.dart';

class BusinessesVerticalScrollView extends StatelessWidget {
  final HomePageBuyerViewModel viewModel;

  const BusinessesVerticalScrollView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.filteredBusinesses.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "No hay negocios para mostrar.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: viewModel.filteredBusinesses.length,
          itemBuilder: (context, index) {
            final business = viewModel.filteredBusinesses[index];
            return GestureDetector(
              child: BusinessCardView(business: business),
              onTap: () => genericSnackbar(
                context,
                'El detalle del negocio ${business.name} no se encuentra disponible.',
                Colors.yellow,
                Colors.black,
              ),
            );
          },
        ),
      ),
    );
  }
}
