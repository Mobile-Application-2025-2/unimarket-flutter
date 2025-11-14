import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unimarket/ui/core/ui/navigation_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location location = Location();
  LocationData? _currentLocation;
  bool _isCameraMoved = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    var permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) return;

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    final loc = await location.getLocation();
    setState(() => _currentLocation = loc);

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        _currentLocation = newLoc;
      });

      if (_mapController != null && !_isCameraMoved) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(newLoc.latitude!, newLoc.longitude!)),
        );
        _isCameraMoved = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 19,
                tilt: 0.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              style: '''
[
  { "featureType": "poi", "stylers": [ {"visibility": "off"} ] },
  { "featureType": "transit", "stylers": [ {"visibility": "off"} ] },
  { "featureType": "road", "elementType": "labels", "stylers": [ {"visibility": "off"} ] }
]
''',
            ),
      bottomNavigationBar: const UnimarketNavigationBar(),
    );
  }
}
