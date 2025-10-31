import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  FirebaseAuthService(this._auth, this._db);

  /// Stream of auth state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Sign in with email and password
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// Sign up with email, password, and name
  Future<User?> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    String? accountType,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;

    if (user != null) {
      // Update display name
      await user.updateDisplayName(name);

      // Create user document in Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'accountType': accountType ?? 'buyer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send email verification (optional, fail silently)
      try {
        await user.sendEmailVerification();
      } catch (_) {
        // Email verification failed, but account is created
      }
    }

    return user;
  }

  /// Sign out current user
  Future<void> signOut() => _auth.signOut();

  /// Reset password for email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;
}

