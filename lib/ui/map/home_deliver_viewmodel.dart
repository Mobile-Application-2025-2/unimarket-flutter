/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/services/places_service.dart';

class HomeDeliverViewModel extends ChangeNotifier {
  final PlacesService _placesService;

  HomeDeliverViewModel(this._placesService);

  // State
  GoogleMapController? _mapController;
  CameraPosition _camera = const CameraPosition(
    target: LatLng(4.6482837, -74.247894), // Bogotá fallback
    zoom: 14,
  );
  bool _isLoading = true;
  String? _errorMessage;
  final Set<Marker> _markers = {};
  final Map<String, PlaceLite> _placesById = {};
  Position? _currentPosition;

  // Getters
  GoogleMapController? get mapController => _mapController;
  CameraPosition get camera => _camera;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<Marker> get markers => _markers;
  Map<String, PlaceLite> get placesById => _placesById;
  Position? get currentPosition => _currentPosition;

  // Methods
  Future<void> init() async {
    await _initLocation();
  }

  Future<void> _initLocation() async {
    _setLoading(true);
    _clearError();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Activa el GPS del dispositivo.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _setError('Permiso de ubicación denegado.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = pos;
      final newCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 16,
      );

      _camera = newCamera;
      _setLoading(false);

      _mapController?.animateCamera(CameraUpdate.newCameraPosition(newCamera));

      // Load nearby restaurants after we have the user's location
      // Note: context will be passed from the view
    } catch (e) {
      _setError('Error obteniendo ubicación: $e');
    }
  }

  Future<void> loadNearbyRestaurants(double lat, double lng, BuildContext context, {int radiusMeters = 1200, String rankPreference = 'DISTANCE'}) async {
    try {
      _clearError();
      final results = await _placesService.searchNearby(
        latitude: lat,
        longitude: lng,
        radiusMeters: radiusMeters,
        rankPreference: rankPreference,
      );

      if (results.isEmpty) {
        _markers.clear();
        _placesById.clear();
        _setError('No se encontraron restaurantes cercanos.');
        notifyListeners();
        return;
      }

      final Set<Marker> newMarkers = {};
      final Map<String, PlaceLite> newPlacesById = {};

      for (final place in results) {
        newPlacesById[place.id] = place;
        newMarkers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(title: place.name),
            onTap: () => openPlace(place, context),
          ),
        );
      }

      _placesById.clear();
      _placesById.addAll(newPlacesById);
      _markers.clear();
      _markers.addAll(newMarkers);
      notifyListeners();
    } catch (e) {
      _setError('Error consultando restaurantes: $e');
    }
  }

  void openPlace(PlaceLite place, BuildContext context) {
    final photoUrl = _placesService.buildPhotoUrl(place.firstPhotoName);
    final priceText = formatPriceLevel(place.priceLevel);
    
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
                      Text(place.rating!.toStringAsFixed(1)),
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
                    onPressed: () => launchDirections(place.latitude, place.longitude, place.name),
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

  Future<void> launchDirections(double lat, double lng, String name) async {
    final encodedName = Uri.encodeComponent(name);
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$encodedName');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> centerOnUserLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      _currentPosition = pos;
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude),
          16,
        ),
      );
      notifyListeners();
    } catch (e) {
      _setError('Error centrando ubicación: $e');
    }
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  String? formatPriceLevel(String? level) {
    if (level == null) return null;
    // API returns enums like PRICE_LEVEL_INEXPENSIVE, PRICE_LEVEL_MODERATE, etc.
    if (level.contains('INEXPENSIVE')) return '€'; // cheap
    if (level.contains('MODERATE')) return '€€';
    if (level.contains('EXPENSIVE')) return '€€€';
    if (level.contains('VERY_EXPENSIVE')) return '€€€€';
    return null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
*/