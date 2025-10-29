import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../model/shared/services/auth_service.dart';
import '../../../../model/auth/entities/auth_user.dart';

class SessionViewModel extends ChangeNotifier {
  final AuthService _authService;
  StreamSubscription<AppUser?>? _authSubscription;
  
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  SessionViewModel(this._authService) {
    _initializeAuthState();
  }

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // User properties for convenience
  String? get userId => _currentUser?.id;
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser?.name;
  String? get userType => _currentUser?.type;
  String get displayName => _currentUser?.name ?? _currentUser?.email ?? 'User';

  void _initializeAuthState() {
    _currentUser = _authService.currentUser;
    _authSubscription = _authService.onAuthStateChanged.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String type,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signUp(
        name: name,
        email: email,
        password: password,
        type: type,
      );
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signOut();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email: email);
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
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
