import 'package:cloud_firestore/cloud_firestore.dart';

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

    return Position(
      geoHash: map['geohash'] as String,
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }
}

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
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Documento nulo o vacío");
    }

    final positionMap = data['position'] as Map<String, dynamic>;

    final positionModel = Position.fromMap(positionMap);

    return GeoLocationCollection(
      businessId: data['business_id'] as String,
      position: positionModel,
    );
  }
}
