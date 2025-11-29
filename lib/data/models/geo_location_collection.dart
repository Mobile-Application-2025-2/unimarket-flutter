import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';


/// Represents a geographic position with latitude, longitude, and geohash.
class Position {
  String geoHash;
  double latitude;
  double longitude;

  Position({
    required this.geoHash,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'geohash': geoHash,
      'geopoint': GeoPoint(latitude, longitude),
    };
  }

  factory Position.fromMap(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['geopoint'] as GeoPoint;
    
    String? geohashFromMap = map['geohash'] as String?;
    String geoHash;
    
    if (geohashFromMap == null || geohashFromMap.isEmpty) {
      final geoFirePoint = GeoFirePoint(geoPoint);
      geoHash = geoFirePoint.geohash;
    } else {
      geoHash = geohashFromMap;
    }

    return Position(
      geoHash: geoHash,
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }
}


/// Represents a business location with geographic positioning data.
class GeoLocationCollection {
  String businessId;
  Position position;

  GeoLocationCollection({required this.businessId, required this.position});

  Map<String, dynamic> toMap() {
    return {
      'business_id': businessId,
      'position': position.toMap(),
    };
  }

  factory GeoLocationCollection.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final positionMap = data['position'] as Map<String, dynamic>;

    final positionModel = Position.fromMap(positionMap);

    return GeoLocationCollection(
      businessId: data['business_id'] as String,
      position: positionModel,
    );
  }
}
