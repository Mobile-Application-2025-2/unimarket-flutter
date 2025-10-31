import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import '../../profile_buyer/view_model/profile_buyer_viewmodel.dart';
import '../widget/profile_header.dart';
import '../widget/profile_section_card.dart';
import '../widget/profile_row_item.dart';
import '../widget/profile_section_title_row.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/core/ui/unimarket_header.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

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
              if (viewModel.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final name = viewModel.displayName;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UnimarketHeader(title: 'UniMarket'),

                  const SizedBox(height: 16),

                  ProfileHeader(
                    userName: name,
                    onAvatarTap: () => notImplementedFunctionalitySnackbar(context),
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
                          onTap: () async {
                            await viewModel.logout();
                            if (!context.mounted) return;
                            context.go(Routes.login);
                          },
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


