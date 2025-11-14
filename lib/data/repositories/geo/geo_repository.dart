import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:location/location.dart';
import 'package:unimarket/data/daos/geo_location_dao.dart';
import 'package:unimarket/data/models/geo_location_collection.dart';

class GeoRepository {
  final _location = Location();
  final _geoLocationDao = GeoLocationDao();

  Stream<List<GeoLocationCollection>> getNearbyBusinesses(
      double lat, double lng, double radiusKm) {

    final center = GeoFirePoint(lat, longitude: lng);

    return GeoflutterfirePlus.queryList(
      collectionRef: _collectionRef,
      center: center,
      radiusInKm: radiusKm,
      field: _geoField,
      // Usamos el snapshotStream en lugar del get() para obtener un Stream en tiempo real
      queryMode: QueryMode.snapshotStream,
    );
  }

  // Función 2: Combina Ubicación + GeoQuery (el Stream dinámico)
  // Devuelve un Stream<List<DocumentSnapshot>> que se actualiza al mover el usuario.
  Stream<List<GeoLocationCollection>> watchNearbyBusinesses() async* {

    // El manejo de permisos debe ir antes de llamar a watchNearbyBusinesses

    // 2. Usar asyncExpand para encadenar la ubicación y la query de Firestore
    yield* _location.onLocationChanged.asyncExpand((pos) {
      if (pos.latitude != null && pos.longitude != null) {
        // Ejecuta getNearbyBusinesses con la nueva posición y lo inyecta en el Stream.
        return getNearbyBusinesses(pos.latitude!, pos.longitude!, 2); // 2 km
      }
      // Si la posición no es válida, no emite nada o emite una lista vacía
      return Stream.value([]);
    });
  }
}