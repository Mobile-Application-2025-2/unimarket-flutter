import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unimarket/ui/catalog/view/explore_buyer.dart';
import 'package:unimarket/services/places_service.dart';

class MapBackgroundPage extends StatefulWidget {
  const MapBackgroundPage({super.key});

  @override
  State<MapBackgroundPage> createState() => _MapBackgroundPageState();
}

class _MapBackgroundPageState extends State<MapBackgroundPage> {
  GoogleMapController? _controller;
  CameraPosition _camera = const CameraPosition(
    target: LatLng(4.6482837, -74.247894), // Bogotá fallback
    zoom: 14,
  );
  bool _loading = true;
  String? _error;
  final Set<Marker> _markers = {};
  final Map<String, PlaceLite> _placesById = {};
  static const String _placesApiKey = 'AIzaSyDmWwy5o6U0ELq2oDwYBkjmFQgdOabADxE';
  late final PlacesService _placesService = PlacesService(apiKey: _placesApiKey);

  final _brandYellow = const Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = 'Activa el GPS del dispositivo.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() => _error = 'Permiso de ubicación denegado.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 16,
      );

      setState(() {
        _camera = newCamera;
        _loading = false;
        _error = null;
      });

      _controller?.animateCamera(CameraUpdate.newCameraPosition(newCamera));

      // Load nearby restaurants after we have the user's location
      await _loadNearbyRestaurants(pos.latitude, pos.longitude, radiusMeters: 1200);
    } catch (e) {
      setState(() => _error = 'Error obteniendo ubicación: $e');
    }
  }

  Future<void> _loadNearbyRestaurants(double lat, double lng, {int radiusMeters = 1200, String rankPreference = 'DISTANCE'}) async {
    try {
      setState(() {
        _error = null;
      });
      final results = await _placesService.searchNearby(
        latitude: lat,
        longitude: lng,
        radiusMeters: radiusMeters,
        rankPreference: rankPreference,
      );
      if (results.isEmpty) {
        setState(() {
          _markers.clear();
          _placesById.clear();
          _error = 'No se encontraron restaurantes cercanos.';
        });
        return;
      }

      final Set<Marker> markers = {};
      final Map<String, PlaceLite> byId = {};
      for (final place in results) {
        byId[place.id] = place;
        markers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(title: place.name),
            onTap: () => _openPlace(place),
          ),
        );
      }

      setState(() {
        _placesById
          ..clear()
          ..addAll(byId);
        _markers
          ..clear()
          ..addAll(markers);
      });
    } catch (e) {
      setState(() {
        _error = 'Error consultando restaurantes: $e';
      });
    }
  }

  void _openPlace(PlaceLite place) {
    final photoUrl = _placesService.buildPhotoUrl(place.firstPhotoName);
    final priceText = _formatPriceLevel(place.priceLevel);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (photoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      photoUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  place.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (place.rating != null) ...[
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${place.rating!.toStringAsFixed(1)}'),
                      const SizedBox(width: 12),
                    ],
                    if (priceText != null) Text(priceText, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchDirections(place.latitude, place.longitude, place.name),
                    icon: const Icon(Icons.directions),
                    label: const Text('Cómo llegar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _formatPriceLevel(String? level) {
    if (level == null) return null;
    // API returns enums like PRICE_LEVEL_INEXPENSIVE, PRICE_LEVEL_MODERATE, etc.
    if (level.contains('INEXPENSIVE')) return ''; // cheap
    if (level.contains('MODERATE')) return '';
    if (level.contains('EXPENSIVE')) return '';
    if (level.contains('VERY_EXPENSIVE')) return '';
    return null;
  }

  Future<void> _launchDirections(double lat, double lng, String name) async {
    final encodedName = Uri.encodeComponent(name);
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$encodedName');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          GoogleMap(
            initialCameraPosition: _camera,
            onMapCreated: (c) => _controller = c,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
          ),

          // Estado (opcional)
          if (_loading || _error != null)
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
                    _error ?? 'Obteniendo ubicación…',
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
            child: _InfoCard(brandYellow: _brandYellow),
          ),

          // 4) FAB de ubicación (encima del card, PERO debajo del footer)
          Positioned(
            right: 16,
            bottom: 300, // ajusta 120–160 a gusto
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFF5A623),
              onPressed: () async {
                try {
                  final pos = await Geolocator.getCurrentPosition();
                  _controller?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(pos.latitude, pos.longitude),
                      16,
                    ),
                  );
                } catch (_) {}
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // 5) Footer (lo pintamos al FINAL para que quede arriba de todo)
          Positioned(
            left: 0,
            right: 0,
            bottom: -20,
            child: _FooterBar(brandYellow: _brandYellow),
          ),
        ],
      ),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ExploreBuyerScreen()),
                );
              },
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

