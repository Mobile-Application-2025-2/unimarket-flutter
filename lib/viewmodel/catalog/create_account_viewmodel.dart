import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/session_controller.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final SessionController _sessionController;

  CreateAccountViewModel(this._sessionController);

  bool _isLoading = false;
  String? _errorMessage;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String? _accountType; // 'buyer' | 'deliver' | 'business'
  bool _acceptedPrivacy = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get accountType => _accountType;
  bool get acceptedPrivacy => _acceptedPrivacy;

  bool get isValid {
    final emailOk = RegExp(r'^.+@.+\..+$').hasMatch(_email.trim());
    final nameOk = _name.trim().isNotEmpty;
    final passwordOk = _password.isNotEmpty && _password.length >= 6;
    final confirmOk = _confirmPassword == _password;
    final typeOk = _accountType != null;
    final privacyOk = _acceptedPrivacy;
    return emailOk && nameOk && passwordOk && confirmOk && typeOk && privacyOk;
  }

  void setName(String v) { _name = v; _clearError(); notifyListeners(); }
  void setEmail(String v) { _email = v; _clearError(); notifyListeners(); }
  void setPassword(String v) { _password = v; _clearError(); notifyListeners(); }
  void setConfirmPassword(String v) { _confirmPassword = v; _clearError(); notifyListeners(); }
  void setAccountType(String? v) { _accountType = v; _clearError(); notifyListeners(); }
  void setAcceptedPrivacy(bool v) { _acceptedPrivacy = v; _clearError(); notifyListeners(); }

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
      final user = await _sessionController.signup(
        name: _name.trim(),
        email: _email.trim(),
        password: _password,
        type: _accountType!,
      );
      _clearError();
      return user.name; // for next screen greeting
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


