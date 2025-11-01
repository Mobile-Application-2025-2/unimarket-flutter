import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/models/business_collection.dart';
import 'package:unimarket/utils/result.dart';

class BusinessDao {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('businesses');

  Future<Result<List<BusinessCollection>>> getAllBusiness() async {
    try {
      final querySnapshot = await _collection.get();
      final businessCollection = querySnapshot.docs.map((doc) {
        return BusinessCollection.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      });

      return Result.ok(businessCollection.toList());
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Stream<List<BusinessCollection>> getBusinessesStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BusinessCollection.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
