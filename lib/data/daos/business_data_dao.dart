import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/utils/result.dart';


class BusinessDataDao {
  BusinessDataDao({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  late final _collection = _firestore.collection('businesses');

  /// Check if a business user has already submitted their data
  Future<bool> hasSubmission(String userId) async {
    try {
      final snap = await _collection.doc(userId).get();
      return snap.exists;
    } catch (_) {
      return false;
    }
  }

  /// Save business data (no photo upload)
  Future<Result<void>> saveBusinessData({
    required String userId,
    required String businessId,
    required String address,
    required String category,
  }) async {
    try {
      await _collection.doc(userId).set({
        'userId': userId,
        'businessId': businessId,
        'address': address,
        'category': category,
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return Result.ok(null);
    } on FirebaseException catch (e) {
      return Result.error(Exception(e.message ?? 'Firebase error while saving business data'));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> getBusinessData(String userId) async {
    try {
      final doc = await _collection.doc(userId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (_) {
      return null;
    }
  }
}

