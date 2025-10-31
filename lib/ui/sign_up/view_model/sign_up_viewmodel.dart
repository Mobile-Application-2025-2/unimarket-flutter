import 'package:flutter/foundation.dart';
import '../widgets/sign_up_state.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpState _state = const SignUpState();

  SignUpState get state => _state;

  void _set(SignUpState newState) {
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
