import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/shared/services/firebase_auth_service.dart';

class LoginUiState {
  final bool loading;
  final String email;
  final String password;
  final bool showPassword;
  final String? error;

  const LoginUiState({
    this.loading = false,
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.error,
  });

  LoginUiState copyWith({
    bool? loading,
    String? email,
    String? password,
    bool? showPassword,
    String? Function()? error,
  }) {
    return LoginUiState(
      loading: loading ?? this.loading,
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      error: error != null ? error() : this.error,
    );
  }

  bool get isEmailValid {
    return RegExp(r'^\S+@\S+\.\S+$').hasMatch(email.trim());
  }

  bool get isPasswordValid => password.isNotEmpty;

  bool get canSubmit => !loading && isEmailValid && isPasswordValid;
}

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth;

  LoginViewModel(this._auth);

  LoginUiState _state = const LoginUiState();

  LoginUiState get state => _state;

  void _set(LoginUiState newState) {
    _state = newState;
    notifyListeners();
  }

  void setEmail(String value) {
    _set(_state.copyWith(email: value, error: () => null));
  }

  void setPassword(String value) {
    _set(_state.copyWith(password: value, error: () => null));
  }

  void togglePasswordVisibility() {
    _set(_state.copyWith(showPassword: !_state.showPassword));
  }

  void clearError() {
    _set(_state.copyWith(error: () => null));
  }

  /// Sign in with email and password
  /// Returns true if login was successful, false otherwise
  Future<bool> signIn() async {
    // Guard: check if inputs are valid
    if (!_state.canSubmit) {
      _set(_state.copyWith(error: () => 'Please fill in all fields correctly'));
      return false;
    }

    _set(_state.copyWith(loading: true, error: () => null));

    try {
      final user = await _auth.signInWithEmailPassword(
        email: _state.email.trim(),
        password: _state.password,
      );

      // Check if user exists
      if (user == null) {
        _set(_state.copyWith(loading: false, error: () => 'Login failed'));
        return false;
      }

      // Check if email is verified
      if (!user.emailVerified) {
        _set(_state.copyWith(
          loading: false,
          error: () => 'Please verify your email before logging in. Check your inbox.',
        ));
        // Sign out the user since email is not verified
        await _auth.signOut();
        return false;
      }

      // Success
      _set(_state.copyWith(loading: false));
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      _set(_state.copyWith(loading: false, error: () => errorMessage));
      return false;
    } catch (error) {
      _set(_state.copyWith(loading: false, error: () => 'An unexpected error occurred'));
      return false;
    }
  }

  Future<void> resetPassword() async {
    if (_state.email.trim().isEmpty) {
      _set(_state.copyWith(error: () => 'Please enter your email address'));
      return;
    }

    if (!_state.isEmailValid) {
      _set(_state.copyWith(error: () => 'Please enter a valid email address'));
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _state.email.trim());
      _set(_state.copyWith(error: () => null));
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      _set(_state.copyWith(error: () => errorMessage));
    } catch (error) {
      _set(_state.copyWith(error: () => 'An unexpected error occurred'));
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Login failed. Please try again';
    }
  }
}
