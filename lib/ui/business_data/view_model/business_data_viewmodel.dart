import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/business_data_state.dart';
import 'package:unimarket/data/daos/business_data_dao.dart';
import 'package:unimarket/utils/result.dart';
import 'package:unimarket/data/services/camera_service.dart';

class BusinessDataViewModel extends ChangeNotifier {
  final CameraService _camera;
  final BusinessDataDao _dao;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BusinessDataState _state = const BusinessDataState();
  BusinessDataState get state => _state;

  BusinessDataViewModel(this._camera, this._dao, {String? initialUserName}) {
    if (initialUserName != null && initialUserName.isNotEmpty) {
      _set(_state.copyWith(userName: initialUserName));
    } else {
      _hydrateUserName();
    }
  }

  void _set(BusinessDataState s) {
    _state = s;
    notifyListeners();
  }

  void _hydrateUserName() {
    final user = _auth.currentUser;
    if (user == null) {
      _set(_state.copyWith(userName: ''));
      return;
    }

    String firstName = '';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      firstName = user.displayName!.split(' ').first;
    } else if (user.email != null) {
      firstName = user.email!.split('@').first;
    }

    _set(_state.copyWith(userName: firstName));
  }

  void setBusinessId(String v) {
    final onlyDigits = v.replaceAll(RegExp(r'[^0-9]'), '');
    _set(_state.copyWith(businessId: onlyDigits));
  }

  void setAddress(String v) {
    _set(_state.copyWith(address: v));
  }

  void setCategory(String v) {
    _set(_state.copyWith(category: v));
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

  Future<void> submit() async {
    if (!state.canSubmit || state.loading) return;

    _set(state.copyWith(loading: true, error: null));

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _set(state.copyWith(loading: false, error: 'User not logged in'));
        return;
      }

      final result = await _dao.saveBusinessData(
        userId: user.uid,
        businessId: state.businessId.trim(),
        address: state.address.trim(),
        category: state.category.trim(),
      );

      if (result is Ok<void>) {
        _set(state.copyWith(
          loading: false,
          submitted: true,
        ));
      } else if (result is Error<void>) {
        _set(state.copyWith(loading: false, error: result.error.toString()));
      } else {
        _set(state.copyWith(loading: false, error: 'Submission failed'));
      }
    } catch (e) {
      _set(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void clearError() => _set(state.copyWith(error: null));
}

