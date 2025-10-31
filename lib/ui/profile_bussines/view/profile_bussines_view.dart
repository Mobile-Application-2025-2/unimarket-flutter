import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import '../view_model/profile_bussines_viewmodel.dart';
import '../../core/ui/unimarket_header.dart';
import '../../core/ui/navigation_bar.dart';
import '../../core/ui/profile_widgets/profile_avatar.dart';
import '../../core/ui/profile_widgets/profile_section_card.dart';
import '../../core/ui/profile_widgets/profile_row_tile.dart';
import '../../core/ui/profile_widgets/profile_section_title_row.dart';

class ProfileBussinesView extends StatelessWidget {
  const ProfileBussinesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProfileBussinesViewModel>();

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
                  const UnimarketHeader(),

                  const SizedBox(height: 16),

                  ProfileAvatar(
                    userName: name,
                    onAvatarTap: () => notImplementedFunctionalitySnackbar(context),
                  ),

                  const SizedBox(height: 16),

                  // Section 1: Business Info + Addresses
                  ProfileSectionCard(
                    child: Column(
                      children: [
                        ProfileRowTile(
                          icon: Icons.badge_outlined,
                          label: 'Bussiness Info',
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

                  // Section 2: Purchases (History equivalent)
                  ProfileSectionCard(
                    child: Column(
                      children: [
                        const ProfileSectionTitleRow(
                          leadingIcon: Icons.access_time,
                          title: 'Compras',
                          actionText: 'Ver todas',
                        ),
                        const SizedBox(height: 8),
                        ProfileRowTile(
                          icon: Icons.person_outline,
                          label: 'Juan Perez',
                          subtitle: '24 octubre',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.person_outline,
                          label: 'Juan Perez',
                          subtitle: '23 octubre',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section 3: Actions
                  ProfileSectionCard(
                    child: Column(
                      children: [
                        ProfileRowTile(
                          icon: Icons.inventory_2_outlined,
                          label: 'Productos',
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
                          icon: Icons.reviews_outlined,
                          label: 'User Reviews',
                          onTap: () => notImplementedFunctionalitySnackbar(context),
                        ),
                        const Divider(height: 1),
                        ProfileRowTile(
                          icon: Icons.logout,
                          label: 'Log Out',
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

