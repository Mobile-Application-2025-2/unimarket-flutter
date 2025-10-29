import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../create_account/widgets/session_viewmodel.dart';

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
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  bool get canSubmit => !loading && isEmailValid && password.isNotEmpty;
}

class LoginViewModel extends ChangeNotifier {
  final SessionViewModel _sessionViewModel;

  LoginViewModel(this._sessionViewModel);

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

  Future<void> signIn() async {
    if (!_state.canSubmit) {
      _set(_state.copyWith(error: () => 'Please fill in all fields correctly'));
      return;
    }

    _set(_state.copyWith(loading: true, error: () => null));

    try {
      await _sessionViewModel.signIn(
        email: _state.email.trim(),
        password: _state.password,
      );

      // Success - navigation will be handled by the view
      _set(_state.copyWith(loading: false));
    } on AuthException catch (error) {
      String errorMessage = error.message;
      if (error.statusCode != null) {
        errorMessage = '${error.statusCode} $errorMessage';
      }
      _set(_state.copyWith(loading: false, error: () => errorMessage));
    } catch (error) {
      _set(_state.copyWith(loading: false, error: () => 'An unexpected error occurred'));
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
      await _sessionViewModel.resetPassword(email: _state.email.trim());
      _set(_state.copyWith(error: () => null));
    } on AuthException catch (error) {
      String errorMessage = error.message;
      if (error.statusCode != null) {
        errorMessage = '${error.statusCode} $errorMessage';
      }
      _set(_state.copyWith(error: () => errorMessage));
    } catch (error) {
      _set(_state.copyWith(error: () => 'An unexpected error occurred'));
    }
  }
}

