import 'dart:async';
import 'dart:collection';
import 'dart:math' show pi, atan2, sqrt;

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/models/business_collection.dart';
import 'package:unimarket/data/models/geo_location_collection.dart';
import 'package:unimarket/data/repositories/geo/geo_repository.dart';
import 'package:unimarket/utils/result.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel() {
    _initializeGeohashes();
  }

  final GeoRepository _repository = GeoRepository();
  final BusinessDao _businessDao = BusinessDao();
  final Location _location = Location();

  StreamSubscription<List<GeoLocationCollection>>? _businessesSubscription;
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _initializeGeohashes() async {
    try {
      await _repository.updateAllGeohashesIfEmpty();
    } catch (e) {}
  }
  
  List<GeoLocationCollection> _nearbyBusinesses = [];
  final List<GeoLocationCollection> _allBusinesses = [];
  final Map<String, String> _businessNames = {};
  bool _isLoading = false;
  String? _error;
  double? _currentLatitude;
  double? _currentLongitude;
  static const double _radiusInKm = 0.08;
  static const double _searchRadiusInKm = 0.085;

  UnmodifiableListView<GeoLocationCollection> get nearbyBusinesses => UnmodifiableListView(_nearbyBusinesses);
  UnmodifiableListView<GeoLocationCollection> get filteredBusinesses => UnmodifiableListView(_getFilteredBusinesses());
  bool get isLoading => _isLoading;
  String? get error => _error;
  double? get currentLatitude => _currentLatitude;
  double? get currentLongitude => _currentLongitude;
  bool get hasLocation => _currentLatitude != null && _currentLongitude != null;
  double get radiusInKm => _radiusInKm;

  /// Obtiene el nombre de un negocio por su ID
  String getBusinessName(String businessId) {
    return _businessNames[businessId] ?? 'Negocio $businessId';
  }

  /// Inicializa la ubicación y solicita los permisos necesarios
  Future<bool> initializeLocation() async {
    var permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      _error = 'Permiso de ubicación denegado';
      notifyListeners();
      return false;
    }

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _error = 'Servicio de ubicación deshabilitado';
        notifyListeners();
        return false;
      }
    }

    try {
      final loc = await _location.getLocation();
      if (loc.latitude != null && loc.longitude != null) {
        _currentLatitude = loc.latitude;
        _currentLongitude = loc.longitude;
        _startWatchingBusinesses(loc.latitude!, loc.longitude!);
        notifyListeners();
      }

      // Escuchar cambios de ubicación
      _locationSubscription?.cancel();
      _locationSubscription = _location.onLocationChanged.listen((newLoc) {
        if (newLoc.latitude != null && newLoc.longitude != null) {
          _currentLatitude = newLoc.latitude;
          _currentLongitude = newLoc.longitude;
          updateLocation(newLoc.latitude!, newLoc.longitude!);
        }
      });

      return true;
    } catch (e) {
      _error = 'Error al obtener la ubicación: $e';
      notifyListeners();
      return false;
    }
  }

  void _startWatchingBusinesses(double lat, double lng) {
    _businessesSubscription?.cancel();
    _businessesSubscription = watchNearbyBusinesses(lat, lng).listen(
      (businesses) {
        // Los negocios ya están procesados en watchNearbyBusinesses
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        _nearbyBusinesses = [];
        _allBusinesses.clear();
        notifyListeners();
      },
    );
  }

  Stream<List<GeoLocationCollection>> watchNearbyBusinesses(
    double lat,
    double lng,
  ) {
    _currentLatitude = lat;
    _currentLongitude = lng;
    _isLoading = true;
    _error = null;
    notifyListeners();

    return _repository.getNearbyBusinessesAsModels(
      lat,
      lng,
      _searchRadiusInKm,
    ).asyncMap((businesses) async {
      _allBusinesses.clear();
      _allBusinesses.addAll(businesses);
      
      // Cargar los nombres de los negocios que aún no tenemos
      await _loadBusinessNames(businesses.map((b) => b.businessId).toList());
      
      _filterBusinessesByCurrentLocation();
      _nearbyBusinesses = _getFilteredBusinesses();
      _isLoading = false;
      _error = null;
      notifyListeners();
      return businesses;
    }).handleError((error) {
      _error = error.toString();
      _isLoading = false;
      _nearbyBusinesses = [];
      _allBusinesses.clear();
      notifyListeners();
      return <GeoLocationCollection>[];
    });
  }

  void updateLocation(double lat, double lng) {
    _currentLatitude = lat;
    _currentLongitude = lng;
    _filterBusinessesByCurrentLocation();
    _nearbyBusinesses = _getFilteredBusinesses();
    
    // Actualizar la búsqueda si hay un cambio significativo
    if (lat != 0 && lng != 0) {
      _startWatchingBusinesses(lat, lng);
    }
    
    notifyListeners();
  }

  Future<void> _loadBusinessNames(List<String> businessIds) async {
    for (final businessId in businessIds) {
      if (!_businessNames.containsKey(businessId)) {
        try {
          final result = await _businessDao.getBussinessById(businessId);
          switch (result) {
            case Ok<BusinessCollection>(value: final business):
              _businessNames[businessId] = business.name;
              break;
            case Error<BusinessCollection>():
              _businessNames[businessId] = 'Negocio desconocido';
              break;
          }
        } catch (e) {
          _businessNames[businessId] = 'Negocio desconocido';
        }
      }
    }
  }

  void _filterBusinessesByCurrentLocation() {
    if (_allBusinesses.isEmpty) {
      return;
    }
    
    if (_currentLatitude == null || _currentLongitude == null) {
      return;
    }
    
    final radiusInMeters = _radiusInKm * 1000;
    
    _nearbyBusinesses = _allBusinesses
        .where((business) {
          final businessLat = business.position.latitude;
          final businessLng = business.position.longitude;
          final distance = _calculateDistance(
            _currentLatitude!,
            _currentLongitude!,
            businessLat,
            businessLng,
          );
          return distance <= radiusInMeters;
        })
        .toList();
  }

  List<GeoLocationCollection> _getFilteredBusinesses() {
    if (_allBusinesses.isEmpty) {
      return [];
    }
    
    if (_currentLatitude == null || _currentLongitude == null) {
      return [];
    }
    
    final radiusInMeters = _radiusInKm * 1000;
    
    return _allBusinesses
        .where((business) {
          final businessLat = business.position.latitude;
          final businessLng = business.position.longitude;
          final distance = _calculateDistance(
            _currentLatitude!,
            _currentLongitude!,
            businessLat,
            businessLng,
          );
          return distance <= radiusInMeters;
        })
        .toList();
  }

  /// Calcula la distancia en metros entre dos puntos geográficos usando la fórmula de Haversine
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radio de la Tierra en metros
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = (dLat / 2) * (dLat / 2) +
        _degreesToRadians(lat1) * _degreesToRadians(lat2) *
            (dLon / 2) * (dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _businessesSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
}