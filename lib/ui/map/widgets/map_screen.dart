import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';
import 'package:unimarket/ui/map/view_model/map_vm.dart';


/// Displays a map with nearby businesses and the user's current location.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  bool _isCameraMoved = false;
  final MapViewModel _viewModel = MapViewModel();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final success = await _viewModel.initializeLocation();
    if (success && mounted) {
      // Mover la cámara una vez cuando se obtiene la ubicación inicial
      if (_viewModel.hasLocation && _mapController != null && !_isCameraMoved) {
        _moveCameraToInitialLocation();
      }
    }
  }

  void _moveCameraToInitialLocation() {
    if (_viewModel.currentLatitude == null || _viewModel.currentLongitude == null) {
      return;
    }

    final position = CameraPosition(
      target: LatLng(_viewModel.currentLatitude!, _viewModel.currentLongitude!),
      zoom: 19,
    );
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(position));
    _isCameraMoved = true;
  }

  Set<Marker> _buildMarkers() {
    final filteredBusinesses = _viewModel.filteredBusinesses;
    return filteredBusinesses
        .map((business) {
          final position = business.position;
          final businessName = _viewModel.getBusinessName(business.businessId);
          return Marker(
            markerId: MarkerId(business.businessId),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: businessName,
            ),
          );
        })
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (!_viewModel.hasLocation) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_mapController != null && !_isCameraMoved) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _moveCameraToInitialLocation();
            });
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _viewModel.currentLatitude!,
                _viewModel.currentLongitude!,
              ),
              zoom: 19,
              tilt: 0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            markers: _buildMarkers(),
            circles: _viewModel.hasLocation
                ? {
                    Circle(
                      circleId: const CircleId('user_radius'),
                      center: LatLng(
                        _viewModel.currentLatitude!,
                        _viewModel.currentLongitude!,
                      ),
                      radius: _viewModel.radiusInKm * 1000,
                      fillColor: const Color(0xFFFFC436).withOpacity(0.15),
                      strokeColor: const Color(0xFFFFC436),
                      strokeWidth: 2,
                    ),
                  }
                : {},
            onMapCreated: (controller) {
              _mapController = controller;
              // Mover la cámara si ya tenemos la ubicación
              if (_viewModel.hasLocation && !_isCameraMoved) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _moveCameraToInitialLocation();
                });
              }
            },
            style: '''
[
  { "featureType": "poi", "stylers": [ {"visibility": "off"} ] },
  { "featureType": "transit", "stylers": [ {"visibility": "off"} ] },
  { "featureType": "road", "elementType": "labels", "stylers": [ {"visibility": "off"} ] }
]
''',
          );
        },
      ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}
