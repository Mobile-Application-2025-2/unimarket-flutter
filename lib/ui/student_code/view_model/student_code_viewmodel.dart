import 'dart:io';
import 'package:flutter/foundation.dart';
import '../widget/student_code_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/utils/result.dart';
import 'package:unimarket/data/models/services/camera_service.dart';

class StudentCodeViewModel extends ChangeNotifier {
  final CameraService _camera;
  final StudentCodeDao _dao;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StudentCodeState _state = const StudentCodeState();
  StudentCodeState get state => _state;

  StudentCodeViewModel(this._camera, this._dao, {String? initialUserName}) {
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
      _set(state.copyWith(imageFile: image, loading: false));
    } catch (e) {
      _set(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void removePhoto() {
    _set(state.copyWith(imageFile: null));
  }

  void setStudentCodeText(String v) {
    // Sanitize input: only digits
    final onlyDigits = v.replaceAll(RegExp(r'[^0-9]'), '');
    _set(state.copyWith(studentCodeText: onlyDigits));
  }

  Future<void> submitVerification() async {
    if (state.loading || state.studentCodeText.trim().isEmpty) return;
    _set(state.copyWith(loading: true, error: null));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _set(state.copyWith(loading: false, error: 'User not logged in'));
        return;
      }
      final result = await _dao.saveCode(
        userId: user.uid,
        studentCode: state.studentCodeText.trim(),
      );
      if (result is Ok<void>) {
        _set(state.copyWith(
          loading: false,
          submitted: true,
          isVerified: true,
        ));
      } else if (result is Error<void>) {
        _set(state.copyWith(loading: false, error: result.error.toString()));
      } else {
        _set(state.copyWith(loading: false, error: 'Verification failed'));
      }
    } catch (e) {
      _set(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void setUserName(String v) => _set(state.copyWith(userName: v));
  void clearError() => _set(state.copyWith(error: null));
}
