import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../viewmodel/app/session_viewmodel.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final SessionViewModel _sessionViewModel;

  CreateAccountViewModel(this._sessionViewModel);

  bool _isLoading = false;
  String? _errorMessage;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String? _accountType; // 'buyer' | 'deliver' | 'business'
  bool _acceptedPrivacy = false;

  // Field-specific validation errors
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  // Getters for state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get accountType => _accountType;
  bool get acceptedPrivacy => _acceptedPrivacy;

  // Getters for field-specific errors
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  bool get isValid {
    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _name.trim().isNotEmpty &&
        _email.trim().isNotEmpty &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _accountType != null &&
        _acceptedPrivacy;
  }

  void setName(String v) {
    _name = v;
    _validateName();
    _clearError();
  }

  void setEmail(String v) {
    _email = v;
    _validateEmail();
    _clearError();
  }

  void setPassword(String v) {
    _password = v;
    _validatePasswordMatch();
    _clearError();
  }

  void setConfirmPassword(String v) {
    _confirmPassword = v;
    _validatePasswordMatch();
    _clearError();
  }

  void setAccountType(String? v) {
    _accountType = v;
    _clearError();
    notifyListeners();
  }

  void setAcceptedPrivacy(bool v) {
    _acceptedPrivacy = v;
    _clearError();
    notifyListeners();
  }

  // Validation methods
  void _validateName() {
    if (_name.trim().isEmpty) {
      _nameError = null; // No error for empty field initially
    } else if (_name.trim().length > 30) {
      _nameError = 'Your name cannot exceed 30 characters.';
    } else {
      _nameError = null;
    }
    notifyListeners();
  }

  void _validateEmail() {
    if (_email.trim().isEmpty) {
      _emailError = null; // No error for empty field initially
    } else {
      final regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com|icloud\.com)$',
        caseSensitive: false,
      );
      if (!regex.hasMatch(_email.trim())) {
        _emailError = 'Please use a valid email from a recognized domain (e.g., @gmail.com).';
      } else {
        _emailError = null;
      }
    }
    notifyListeners();
  }

  void _validatePasswordMatch() {
    if (_confirmPassword.isEmpty) {
      _passwordError = null; // No error for empty confirmation initially
    } else if (_password != _confirmPassword) {
      _passwordError = 'Passwords do not match.';
    } else {
      _passwordError = null;
    }
    notifyListeners();
  }

  void clearError() { _clearError(); notifyListeners(); }
  void _clearError() { _errorMessage = null; }

  Future<String?> createAccount() async {
    if (!isValid) {
      _errorMessage = 'Please complete all fields correctly';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    try {
      await _sessionViewModel.signUp(
        name: _name.trim(),
        email: _email.trim(),
        password: _password,
        type: _accountType!,
      );
      _clearError();
      return _name.trim(); // for next screen greeting
    } on AuthException catch (e) {
      String msg = e.message;
      if (e.statusCode != null) {
        msg = '${e.statusCode} $msg';
      }
      _errorMessage = msg;
      return null;
    } catch (_) {
      _errorMessage = 'An unexpected error occurred';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) { _isLoading = v; notifyListeners(); }
}


