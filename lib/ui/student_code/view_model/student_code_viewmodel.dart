import 'dart:io';
import 'package:flutter/foundation.dart';
import '../widget/student_code_state.dart';
import 'package:unimarket/data/models/services/camera_service.dart';

class StudentCodeViewModel extends ChangeNotifier {
  final CameraService _camera;

  StudentCodeState _state = const StudentCodeState();
  StudentCodeState get state => _state;

  StudentCodeViewModel(this._camera, {String? initialUserName, required CameraService cameraService}) {
    if (initialUserName != null && initialUserName.isNotEmpty) {
      _set(_state.copyWith(userName: initialUserName));
    }
  }

  void _set(StudentCodeState s) {
    _state = s;
    notifyListeners();
  }

  Future<void> openCamera() async {
    _set(state.copyWith(loading: true, error: null));
    try {
      final File? image = await _camera.pickImageFromCamera();
      _set(state.copyWith(loading: false, imageFile: image));
    } catch (_) {
      _set(state.copyWith(loading: false, error: 'Unable to access camera'));
    }
  }

  void removePhoto() {
    _set(state.copyWith(imageFile: null, error: null));
  }

  Future<void> submitVerification() async {
    if (!state.canSubmit) return;
    _set(state.copyWith(loading: true, error: null));
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _set(state.copyWith(loading: false, submitted: true, isVerified: true));
    } catch (_) {
      _set(state.copyWith(loading: false, error: 'Verification failed'));
    }
  }

  void setUserName(String v) => _set(state.copyWith(userName: v));
  void clearError() => _set(state.copyWith(error: null));
}
