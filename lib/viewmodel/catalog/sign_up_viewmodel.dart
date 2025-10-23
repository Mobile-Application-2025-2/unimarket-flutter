import 'package:flutter/foundation.dart';

class SignUpViewModel extends ChangeNotifier {
  // State
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }


  // Navigation methods
  void navigateToLogin() {
    // Navigation logic will be handled by the view
    // This method can be used for any pre-navigation logic if needed
    clearError();
  }

  void navigateToCreateAccount() {
    // Navigation logic will be handled by the view
    // This method can be used for any pre-navigation logic if needed
    clearError();
  }
}
