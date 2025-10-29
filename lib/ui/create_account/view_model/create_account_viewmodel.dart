import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/shared/services/firebase_auth_service.dart';

class CreateAccountUiState {
  final bool loading;
  final String? errorMessage;
  final String name;
  final String? nameError;
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final String confirmPassword;
  final String accountType;
  final bool acceptedPrivacy;

  const CreateAccountUiState({
    this.loading = false,
    this.errorMessage,
    this.name = '',
    this.nameError,
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.confirmPassword = '',
    this.accountType = 'buyer',
    this.acceptedPrivacy = false,
  });

  CreateAccountUiState copyWith({
    bool? loading,
    String? Function()? errorMessage,
    String? name,
    String? Function()? nameError,
    String? email,
    String? Function()? emailError,
    String? password,
    String? Function()? passwordError,
    String? confirmPassword,
    String? accountType,
    bool? acceptedPrivacy,
  }) {
    return CreateAccountUiState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      name: name ?? this.name,
      nameError: nameError != null ? nameError() : this.nameError,
      email: email ?? this.email,
      emailError: emailError != null ? emailError() : this.emailError,
      password: password ?? this.password,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      accountType: accountType ?? this.accountType,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }

  bool get passwordsMatch => password.isNotEmpty && password == confirmPassword;

  bool get isValid =>
      !loading &&
      nameError == null &&
      emailError == null &&
      passwordError == null &&
      name.trim().length >= 2 &&
      email.isNotEmpty &&
      password.length >= 6 &&
      passwordsMatch &&
      acceptedPrivacy;
}

class CreateAccountViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth;

  CreateAccountViewModel(this._auth);

  CreateAccountUiState _state = const CreateAccountUiState();

  CreateAccountUiState get state => _state;

  void _set(CreateAccountUiState newState) {
    _state = newState;
    notifyListeners();
  }

  void setName(String value) {
    _set(_state.copyWith(
      name: value,
      nameError: () => _validateName(value),
      errorMessage: () => null,
    ));
  }

  void setEmail(String value) {
    _set(_state.copyWith(
      email: value,
      emailError: () => _validateEmail(value),
      errorMessage: () => null,
    ));
  }

  void setPassword(String value) {
    _set(_state.copyWith(
      password: value,
      passwordError: () => _validatePasswordMatch(value, _state.confirmPassword),
      errorMessage: () => null,
    ));
  }

  void setConfirmPassword(String value) {
    _set(_state.copyWith(
      confirmPassword: value,
      passwordError: () => _validatePasswordMatch(_state.password, value),
      errorMessage: () => null,
    ));
  }

  void setAccountType(String value) {
    _set(_state.copyWith(
      accountType: value,
      errorMessage: () => null,
    ));
  }

  void setAcceptedPrivacy(bool value) {
    _set(_state.copyWith(
      acceptedPrivacy: value,
      errorMessage: () => null,
    ));
  }

  void clearError() {
    _set(_state.copyWith(errorMessage: () => null));
  }

  // Validation methods
  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return null; // No error for empty field initially
    } else if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    } else if (name.trim().length > 30) {
      return 'Your name cannot exceed 30 characters';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) {
      return null; // No error for empty field initially
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com|icloud\.com)$',
      caseSensitive: false,
    );
    if (!regex.hasMatch(email.trim())) {
      return 'Please use a valid email from a recognized domain (e.g., @gmail.com)';
    }
    return null;
  }

  String? _validatePasswordMatch(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null; // No error for empty confirmation initially
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Returns the display name on success, null on failure
  Future<String?> createAccount() async {
    if (!_state.isValid) {
      _set(_state.copyWith(errorMessage: () => 'Please complete all fields correctly'));
      return null;
    }

    _set(_state.copyWith(loading: true, errorMessage: () => null));

    try {
      final user = await _auth.signUpWithEmailPassword(
        name: _state.name.trim(),
        email: _state.email.trim(),
        password: _state.password,
        accountType: _state.accountType,
      );
      _set(_state.copyWith(loading: false));
      return user?.displayName ?? _state.name.trim();
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      _set(_state.copyWith(loading: false, errorMessage: () => errorMessage));
      return null;
    } catch (e) {
      _set(_state.copyWith(loading: false, errorMessage: () => 'An unexpected error occurred'));
      return null;
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Could not create the account. Try again';
    }
  }
}
