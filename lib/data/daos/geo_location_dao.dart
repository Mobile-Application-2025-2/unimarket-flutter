import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/models/geo_location_collection.dart';

class GeoLocationDao {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('business_locations');

  Stream<List<GeoLocationCollection>> get() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GeoLocationCollection.fromFirestore(doc);
      }).toList();
    });
  }
}
