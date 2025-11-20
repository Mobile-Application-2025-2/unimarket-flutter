import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:unimarket/data/daos/geo_location_dao.dart';
import 'package:unimarket/data/models/geo_location_collection.dart';


/// Repository for managing geographic location data and geohash operations.
class GeoRepository {
  final _geoLocationDao = GeoLocationDao();
  // final _businessDao = BusinessDao();

  Future<Map<String, int>> updateAllGeohashesIfEmpty() async {
    final result = await _geoLocationDao.updateAllGeohashesIfEmpty();
    return result;
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getNearbyBusinesses(
    double lat,
    double lng,
    double radiusKm,
  ) {
    final collectionRef = _geoLocationDao.collectionRef;

    return GeoCollectionReference(collectionRef)
        .subscribeWithin(
          center: GeoFirePoint(GeoPoint(lat, lng)),
          radiusInKm: radiusKm,
          field: 'position',
          geopointFrom: (data) {
            if (data == null) {
              throw Exception('Data is null');
            }
            final dataMap = data as Map<String, dynamic>;
            final position = dataMap['position'] as Map<String, dynamic>?;
            if (position == null) {
              throw Exception('Position field is null');
            }
            final geoPoint = position['geopoint'];
            if (geoPoint == null || geoPoint is! GeoPoint) {
              throw Exception('GeoPoint is null or invalid');
            }
            return geoPoint;
          },
          strictMode: true,
        )
        .map((snapshots) {
          return snapshots
              .cast<DocumentSnapshot<Map<String, dynamic>>>()
              .toList();
        });
  }

  List<GeoLocationCollection> _convertSnapshotsToModels(
    List<DocumentSnapshot<Map<String, dynamic>>> snapshots,
  ) {
    final results = <GeoLocationCollection>[];
    for (final doc in snapshots) {
      try {
        final data = doc.data();
        if (data != null) {
          final position = data['position'] as Map<String, dynamic>?;
          if (position != null) {
            final currentGeohash = position['geohash'] as String?;
            if (currentGeohash == null ||
                currentGeohash.isEmpty ||
                currentGeohash.trim().isEmpty) {
              _geoLocationDao
                  .updateGeohashIfEmpty(doc.id)
                  .catchError((e) => false);
            }
          }
        }

        final geoLocation = GeoLocationCollection.fromFirestore(doc);
        results.add(geoLocation);
      } catch (e) {
        debugPrint("$e");
      }
    }
    return results;
  }

  Stream<List<GeoLocationCollection>> getNearbyBusinessesAsModels(
    double lat,
    double lng,
    double radiusKm,
  ) {
    return getNearbyBusinesses(
      lat,
      lng,
      radiusKm,
    ).map(_convertSnapshotsToModels);
  }
}
