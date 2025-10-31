import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/utils/result.dart';

class StudentCodeDao {
  final FirebaseFirestore _firestore;

  StudentCodeDao({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Save only the student code, no photo.
  Future<Result<void>> saveCode({
    required String userId,
    required String studentCode,
  }) async {
    try {
      await _firestore.collection('student_codes').doc(userId).set({
        'userId': userId,
        'studentCode': studentCode,
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return Result.ok(null);
    } on FirebaseException catch (e) {
      return Result.error(Exception(e.message ?? 'Firebase error while saving code'));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Check if a student already submitted a code
  Future<Result<bool>> hasSubmission(String userId) async {
    try {
      final doc = await _firestore.collection('student_codes').doc(userId).get();
      if (!doc.exists) return Result.ok(false);
      final data = doc.data() ?? {};
      final hasCode = (data['studentCode'] as String?)?.isNotEmpty == true;
      return Result.ok(hasCode);
    } on FirebaseException catch (e) {
      return Result.error(Exception(e.message ?? 'Firebase error while checking submission'));
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }
}


