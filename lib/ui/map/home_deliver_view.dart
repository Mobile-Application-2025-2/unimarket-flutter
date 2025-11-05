import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_deliver_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

class HomeDeliverView extends StatelessWidget {
  const HomeDeliverView({super.key});

  Set<Marker> _buildMarkers(BuildContext context, HomeDeliverViewModel viewModel) {
    return viewModel.markers.map((marker) {
      final place = viewModel.placesById[marker.markerId.value];
      if (place == null) return marker;
      
      return marker.copyWith(
        onTapParam: () => viewModel.openPlace(place, context),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeDeliverViewModel>(
      builder: (context, viewModel, child) {
        // Initialize and load restaurants when the view is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.currentPosition != null) {
            viewModel.loadNearbyRestaurants(
              viewModel.currentPosition!.latitude,
              viewModel.currentPosition!.longitude,
              context,
            );
          }
        });
        return Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              GoogleMap(
                initialCameraPosition: viewModel.camera,
                onMapCreated: (controller) => viewModel.setMapController(controller),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                markers: _buildMarkers(context, viewModel),
              ),

              // Estado (opcional)
              if (viewModel.isLoading || viewModel.errorMessage != null)
                Positioned(
                  left: 16,
                  right: 16,
                  top: 48,
                  child: Material(
                    elevation: 4,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        viewModel.errorMessage ?? 'Obteniendo ubicación…',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              // Card de información
              Positioned(
                left: 16,
                right: 16,
                bottom: 80, // subimos para dar espacio al footer
                child: _InfoCard(brandYellow: const Color(0xFFF5A623)),
              ),

              // FAB de ubicación
              Positioned(
                right: 16,
                bottom: 300, // ajusta 120–160 a gusto
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFFF5A623),
                  onPressed: () => viewModel.centerOnUserLocation(),
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ),

              // Footer
              Positioned(
                left: 0,
                right: 0,
                bottom: -20,
                child: _FooterBar(brandYellow: const Color(0xFFFFC436)),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ---------- Widgets de UI ----------

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.brandYellow});
  final Color brandYellow;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliff Rogers',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Client',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _SmallOutlinedIcon(icon: Icons.chat_bubble_rounded),
                const SizedBox(width: 8),
                _SmallOutlinedIcon(icon: Icons.phone_rounded),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),

            const SizedBox(height: 12),
            const _InfoRow(
              icon: Icons.access_time_filled_rounded,
              label: 'Estimated time',
              trailing: '10mins',
            ),
            const SizedBox(height: 8),
            const _InfoRow(
              icon: Icons.location_on_rounded,
              label: 'Deliver to',
              trailing: 'W - 403',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: brandYellow, width: 1.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'MORE DETAILS',
                  style: TextStyle(
                    color: brandYellow,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _SmallOutlinedIcon extends StatelessWidget {
  const _SmallOutlinedIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const brandYellow = Color(0xFFF5A623);
    return Container(
      width: 40,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: brandYellow, width: 1.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: brandYellow),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar({required this.brandYellow});
  final Color brandYellow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFFFC436),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.white, size: 24),
            ),

            // Search (Selected)
            IconButton(
              onPressed: () { context.go(Routes.exploreBuyer); },
              icon: const Icon(Icons.search, color: Colors.white, size: 24),
            ),

            // Cart
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 24,
              ),
            ),

            // Profile
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

