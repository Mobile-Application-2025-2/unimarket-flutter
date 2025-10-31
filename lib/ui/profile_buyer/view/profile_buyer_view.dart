import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import '../view_model/profile_buyer_viewmodel.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/core/ui/unimarket_header.dart';
import 'package:unimarket/ui/core/ui/profile_widgets/profile_avatar.dart';
import 'package:unimarket/ui/core/ui/profile_widgets/profile_section_card.dart';
import 'package:unimarket/ui/core/ui/profile_widgets/profile_row_tile.dart';
import 'package:unimarket/ui/core/ui/profile_widgets/profile_section_title_row.dart';
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

                  ProfileAvatar(
                    userName: name,
                    onAvatarTap: () => notImplementedFunctionalitySnackbar(context),
                  ),

                  const SizedBox(height: 16),

                  ProfileSectionCard(
                    child: Column(
                      children: [
                        ProfileRowTile(
                          icon: Icons.person_outline,
                          label: 'Personal Info',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.map_outlined,
                          label: 'Addresses',
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
                        ProfileRowTile(
                          icon: Icons.payments_rounded,
                          label: 'Car burguer',
                          subtitle: '24 octubre',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.payments_rounded,
                          label: 'Subway',
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
                        ProfileRowTile(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Cart',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.favorite_border,
                          label: 'Favourite',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.rate_review_outlined,
                          label: 'User Reviews',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.logout,
                          label: 'Log-Out',
                          onTap: () async {
                            await viewModel.logout();
                            if (!context.mounted) return;
                            context.go(Routes.signUp);
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


