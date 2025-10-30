import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import '../../profile_buyer/view_model/profile_buyer_viewmodel.dart';
import '../widget/profile_header.dart';
import '../widget/profile_section_card.dart';
import '../widget/profile_row_item.dart';
import '../widget/profile_section_title_row.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';

class ProfileBuyerView extends StatelessWidget {
  const ProfileBuyerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileBuyerViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              final name = viewModel.displayName;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileHeader(
                    titleText: 'UniMarket',
                    userName: name,
                    logo: const Icon(Icons.shopping_bag_outlined, size: 28, color: Color(0xFFFFC436)),
                    onFavTap: () => notImplementedFunctionalitySnackbar(context),
                    onDeliveriesTap: () => notImplementedFunctionalitySnackbar(context),
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    child: Column(
                      children: [
                        ProfileRowItem(
                          leadingIcon: Icons.person_outline,
                          title: 'Personal Info',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowItem(
                          leadingIcon: Icons.map_outlined,
                          title: 'Addresses',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    child: Column(
                      children: [
                        const ProfileSectionTitleRow(
                          leadingIcon: Icons.access_time,
                          title: 'Historial',
                          actionText: 'Ver todos',
                        ),
                        const SizedBox(height: 8),
                        ProfileRowItem(
                          leadingIcon: Icons.payments_rounded,
                          title: 'Car burguer',
                          subtitle: '24 octubre',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowItem(
                          leadingIcon: Icons.payments_rounded,
                          title: 'Subway',
                          subtitle: '23 octubre',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    child: Column(
                      children: [
                        ProfileRowItem(
                          leadingIcon: Icons.shopping_bag_outlined,
                          title: 'Cart',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowItem(
                          leadingIcon: Icons.favorite_border,
                          title: 'Favourite',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowItem(
                          leadingIcon: Icons.rate_review_outlined,
                          title: 'User Reviews',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowItem(
                          leadingIcon: Icons.logout,
                          title: 'Log Out',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}


