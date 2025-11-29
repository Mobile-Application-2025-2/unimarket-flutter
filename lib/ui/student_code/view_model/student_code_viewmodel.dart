import 'dart:io';
import 'package:flutter/material.dart';
import '../widget/student_code_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/utils/result.dart';
import 'package:unimarket/data/services/camera_service.dart';

class StudentCodeViewModel extends ChangeNotifier {
  final CameraService _camera;
  final StudentCodeDao _dao;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController studentCodeController = TextEditingController();
  bool _isUpdatingController = false;

  StudentCodeState _state = const StudentCodeState();
  StudentCodeState get state => _state;

  StudentCodeViewModel(this._camera, this._dao, {String? initialUserName}) {
    if (initialUserName != null && initialUserName.isNotEmpty) {
      _set(_state.copyWith(userName: initialUserName));
    }
    studentCodeController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_isUpdatingController) return;
    
    setStudentCodeText(studentCodeController.text);
  }

  void _set(StudentCodeState s) {
    _state = s;
    if (studentCodeController.text != s.studentCodeText) {
      _isUpdatingController = true;
      studentCodeController.value = TextEditingValue(
        text: s.studentCodeText,
        selection: TextSelection.collapsed(offset: s.studentCodeText.length),
      );
      _isUpdatingController = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    studentCodeController.dispose();
    super.dispose();
  }

  Future<void> openCamera() async {
    _set(state.copyWith(loading: true, error: null));
    try {
      final File? image = await _camera.pickImageFromCamera();
      if (image == null) {
        _set(state.copyWith(loading: false));
        return;
      }

      String? extractedCode;
      try {
        final extractedText = await _camera.extractTextFromImage(image);
        extractedCode = _extractStudentCode(extractedText);
        
        if (extractedCode != null) {
          debugPrint('OCR - Código de 9 dígitos encontrado: $extractedCode');
        } else {
          debugPrint('OCR - No se encontró un código de 9 dígitos en el texto extraído');
        }
      } catch (e) {
        debugPrint('OCR - Error al extraer texto: $e');
      }

      _set(state.copyWith(
        imageFile: image,
        studentCodeText: extractedCode ?? state.studentCodeText,
        loading: false,
      ));
    } catch (e) {
      _set(state.copyWith(loading: false, error: e.toString()));
    }
  }

  String? _extractStudentCode(String text) {
    final regex = RegExp(r'\b\d{9}\b');
    final match = regex.firstMatch(text);
    
    if (match != null) {
      return match.group(0);
    }

    final longSequenceRegex = RegExp(r'\d{9,}');
    final longMatch = longSequenceRegex.firstMatch(text);
    
    if (longMatch != null) {
      final sequence = longMatch.group(0)!;
      return sequence.substring(0, 9);
    }
    
    return null;
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
