import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../viewmodel/app/session_viewmodel.dart';

class LoginViewModel extends ChangeNotifier {
  final SessionViewModel _sessionViewModel;
  
  LoginViewModel(this._sessionViewModel);

  // State
  bool _isLoading = false;
  String? _errorMessage;
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get email => _email;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isValid => _isEmailValid && _password.isNotEmpty;

  bool get _isEmailValid {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email.trim());
  }

  // Methods
  void setEmail(String value) {
    _email = value;
    _clearError();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _clearError();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    if (!isValid) {
      _errorMessage = 'Please fill in all fields correctly';
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      await _sessionViewModel.signIn(
        email: _email.trim(),
        password: _password,
      );
      
      // Success - navigation will be handled by the view
      _clearError();
    } on AuthException catch (error) {
      String errorMessage = error.message;
      if (error.statusCode != null) {
        errorMessage = '${error.statusCode} $errorMessage';
      }
      _errorMessage = errorMessage;
    } catch (error) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword() async {
    if (_email.trim().isEmpty) {
      _errorMessage = 'Please enter your email address';
      notifyListeners();
      return;
    }

    if (!_isEmailValid) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return;
    }

    try {
      await _sessionViewModel.resetPassword(email: _email.trim());
      _clearError();
    } on AuthException catch (error) {
      String errorMessage = error.message;
      if (error.statusCode != null) {
        errorMessage = '${error.statusCode} $errorMessage';
      }
      _errorMessage = errorMessage;
    } catch (error) {
      _errorMessage = 'An unexpected error occurred';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
