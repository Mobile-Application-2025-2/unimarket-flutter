import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/services/firebase_auth_service_adapter.dart';

class SessionViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth;
  StreamSubscription<User?>? _authSubscription;
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  SessionViewModel(this._auth) {
    _initializeAuthState();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // User properties for convenience
  String? get userId => _user?.uid;
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName;
  String get displayName => _user?.displayName ?? _user?.email ?? 'User';

  void _initializeAuthState() {
    _user = _auth.currentUser;
    _authSubscription = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signOut();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

