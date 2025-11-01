import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:unimarket/data/models/user_collection.dart';
import 'package:unimarket/utils/result.dart';

class CreateAccountDao {
  final FirebaseAuth _auth;
  final CollectionReference _users;

  CreateAccountDao({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _users = (firestore ?? FirebaseFirestore.instance).collection('users');


  Future<Result<UserCollection>> createAccount({
    required String name,
    required String email,
    required String password,
    required String accountType,
  }) async {
    try {
      // 1) Create Auth user
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return Result.error(Exception('Auth user is null after creation'));
      }

      // 2) Update display name (best-effort)
      try {
        await user.updateDisplayName(name.trim());
      } catch (_) {}

      // 3) Send verification email (non-blocking / best-effort)
      try {
        await user.sendEmailVerification();
      } catch (_) {}

      // 4) Persist profile in Firestore
      final profile = UserCollection(
        id: user.uid,
        name: name.trim(),
        email: user.email ?? email.trim(),
        accountType: accountType,
        emailVerified: user.emailVerified,
        createdAt: DateTime.now().toUtc(),
      );
      await _users.doc(user.uid).set(profile.toMap());

      return Result.ok(profile);
    } on FirebaseAuthException catch (e) {
      return Result.error(e);
    } catch (e) {
      // Firestore failure rollback
      try {
        final current = _auth.currentUser;
        if (current != null) {
          await current.delete();
        }
      } catch (_) {}
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  /// Fetch user document by uid. Returns null if not found.
  Future<Result<UserCollection?>> getUserById(String uid) async {
    try {
      final snap = await _users.doc(uid).get();
      if (!snap.exists) return Result.ok(null);
      final data = snap.data() as Map<String, dynamic>;
      return Result.ok(UserCollection.fromFirestore(snap.id, data));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Check whether a user with the given email already exists in Firestore.
  Future<Result<bool>> existsByEmail(String email) async {
    try {
      final q = await _users.where('email', isEqualTo: email.trim()).limit(1).get();
      return Result.ok(q.docs.isNotEmpty);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Update Firestore fields for a user.
  Future<Result<void>> updateUser(UserCollection user) async {
    try {
      await _users.doc(user.id).update(user.toMap());
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Mirror the emailVerified flag in Firestore.
  Future<Result<void>> syncEmailVerified(String uid, {required bool emailVerified}) async {
    try {
      await _users.doc(uid).update({'emailVerified': emailVerified});
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// Delete Firestore document (does not remove Auth user).
  Future<Result<void>> deleteUserDoc(String uid) async {
    try {
      await _users.doc(uid).delete();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}


