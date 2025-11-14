import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:unimarket/data/models/geo_location_collection.dart';

class GeoLocationDao {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('businesses_locations');

  CollectionReference get collectionRef => _collection;

  Stream<List<GeoLocationCollection>> get() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GeoLocationCollection.fromFirestore(doc);
      }).toList();
    });
  }

  Future<bool> updateGeohashIfEmpty(String documentId) async {
    try {
      final doc = await _collection.doc(documentId).get();
      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        return false;
      }

      final position = data['position'] as Map<String, dynamic>?;
      if (position == null) {
        return false;
      }

      final geopoint = position['geopoint'] as GeoPoint?;
      if (geopoint == null) {
        return false;
      }

      final currentGeohash = position['geohash'] as String?;
      
      if (currentGeohash == null || currentGeohash.isEmpty || currentGeohash.trim().isEmpty) {
        final geoFirePoint = GeoFirePoint(geopoint);
        final newGeohash = geoFirePoint.geohash;
        await _collection.doc(documentId).update({
          'position.geohash': newGeohash,
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, int>> updateAllGeohashesIfEmpty() async {
    int totalDocs = 0;
    int updatedDocs = 0;
    int skippedDocs = 0;
    int errorDocs = 0;

    try {
      final snapshot = await _collection.get();
      totalDocs = snapshot.docs.length;

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          skippedDocs++;
          continue;
        }

        final position = data['position'] as Map<String, dynamic>?;
        if (position == null) {
          skippedDocs++;
          continue;
        }

        final geopoint = position['geopoint'] as GeoPoint?;
        if (geopoint == null) {
          skippedDocs++;
          continue;
        }

        final currentGeohash = position['geohash'] as String?;
        
        if (currentGeohash == null || currentGeohash.isEmpty || currentGeohash.trim().isEmpty) {
          try {
            final geoFirePoint = GeoFirePoint(geopoint);
            final newGeohash = geoFirePoint.geohash;
            await _collection.doc(doc.id).update({
              'position.geohash': newGeohash,
            });
            updatedDocs++;
          } catch (e) {
            errorDocs++;
          }
        } else {
          skippedDocs++;
        }
      }

      return {
        'total': totalDocs,
        'updated': updatedDocs,
        'skipped': skippedDocs,
        'errors': errorDocs,
      };
    } catch (e) {
      rethrow;
    }
  }
}
