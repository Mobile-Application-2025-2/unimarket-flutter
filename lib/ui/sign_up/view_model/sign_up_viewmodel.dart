import 'package:flutter/foundation.dart';

class SignUpUiState {
  final bool loading;
  final String? error;

  const SignUpUiState({
    this.loading = false,
    this.error,
  });

  SignUpUiState copyWith({
    bool? loading,
    String? error,
  }) {
    return SignUpUiState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class SignUpViewModel extends ChangeNotifier {
  SignUpUiState _state = const SignUpUiState();

  SignUpUiState get state => _state;

  void _set(SignUpUiState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> startLoading() async {
    _set(_state.copyWith(loading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 500));
    _set(_state.copyWith(loading: false));
  }

  void clearError() {
    _set(_state.copyWith(error: null));
  }
}
