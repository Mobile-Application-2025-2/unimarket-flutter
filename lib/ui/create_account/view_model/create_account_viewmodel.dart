import 'package:flutter/foundation.dart';
import 'package:unimarket/data/daos/create_account_dao.dart';
import '../widgets/create_account_state.dart';
import 'package:unimarket/utils/result.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final CreateAccountDao _dao;

  CreateAccountViewModel({required CreateAccountDao dao}) : _dao = dao;

  CreateAccountState _state = const CreateAccountState();

  CreateAccountState get state => _state;

  void _set(CreateAccountState newState) {
    _state = newState;
    notifyListeners();
  }

  void setName(String value) {
    _set(_state.copyWith(
      name: value,
      nameError: _validateName(value),
      errorMessage: null,
    ));
  }

  void setEmail(String value) {
    _set(_state.copyWith(
      email: value,
      emailError: _validateEmail(value),
      errorMessage: null,
    ));
  }

  void setPassword(String value) {
    _set(_state.copyWith(
      password: value,
      passwordError: _validatePasswordMatch(value, _state.confirmPassword),
      errorMessage: null,
    ));
  }

  void setConfirmPassword(String value) {
    _set(_state.copyWith(
      confirmPassword: value,
      passwordError: _validatePasswordMatch(_state.password, value),
      errorMessage: null,
    ));
  }

  void setAccountType(String value) {
    _set(_state.copyWith(
      accountType: value,
      errorMessage: null,
    ));
  }

  void setAcceptedPrivacy(bool value) {
    _set(_state.copyWith(
      acceptedPrivacy: value,
      errorMessage: null,
    ));
  }

  void clearError() {
    _set(_state.copyWith(errorMessage: null));
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

  Future<void> createAccount() async {
    if (!state.isValid || state.loading) return;

    _set(_state.copyWith(loading: true, errorMessage: null));

    final r = await _dao.createAccount(
      name: state.name,
      email: state.email,
      password: state.password,
      accountType: state.accountType,
    );

    switch (r) {
      case Ok():
        _set(_state.copyWith(loading: false));
        // Navigation is handled by the View

      case Error():
        final msg = _mapError(r.error);
        _set(_state.copyWith(loading: false, errorMessage: msg));
    }
  }

  String _mapError(Object e) {
    final errorStr = e.toString();
    if (errorStr.contains('email-already-in-use')) {
      return 'Email already in use.';
    }
    if (errorStr.contains('invalid-email')) {
      return 'Invalid email.';
    }
    if (errorStr.contains('weak-password')) {
      return 'Weak password.';
    }
    if (errorStr.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    return 'Could not create account. Try again.';
  }
}
