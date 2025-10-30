import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../data/models/services/camera_service.dart';

class StudentCodeViewModel extends ChangeNotifier {
  final CameraService _cameraService;

  StudentCodeViewModel(this._cameraService);

  // State
  bool _isLoading = false;
  String? _errorMessage;
  String _codeText = '';
  File? _capturedImage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get codeText => _codeText;
  File? get capturedImage => _capturedImage;
  bool get isValid => _validateFormat(_codeText);

  void setCode(String value) {
    _codeText = value.trim();
    _clearError();
    notifyListeners();
  }

  Future<void> openCamera() async {
    try {
      _setLoading(true);
      final file = await _cameraService.pickImageFromCamera();
      if (file != null) {
        _capturedImage = file;
      }
    } catch (e) {
      _errorMessage = 'Unable to access camera. Please check your permissions.';
    } finally {
      _setLoading(false);
    }
  }

  void clearImage() {
    _capturedImage = null;
    notifyListeners();
  }

  Future<void> validateAndFetch() async {
    if (!isValid) {
      _errorMessage = 'Please enter a valid code';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      // TODO: Call a service/repository to validate/fetch by code if needed
      _clearError();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  bool _validateFormat(String value) {
    if (value.isEmpty) return false;
    // Example policy: allow any non-empty for now; replace with regex when needed
    return true;
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}


