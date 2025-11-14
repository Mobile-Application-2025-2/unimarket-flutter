import 'package:flutter/foundation.dart';
import 'package:unimarket/utils/singleton.dart';
import 'package:unimarket/data/services/firebase_auth_service_adapter.dart';

class ProfileBussinesViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = Singleton<FirebaseAuthService>().instance;

  String displayName = '';
  String email = '';
  bool loading = true;

  ProfileBussinesViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      displayName = user.displayName ?? user.email?.split('@').first ?? 'User Name Bussines';
      email = user.email ?? '';
    } else {
      displayName = 'User Name Bussines';
      email = '';
    }
    loading = false;
    notifyListeners();
  }

  /// Signs out the user from FirebaseAuth
  Future<void> logout() async {
    try {
      await _authService.signOut();
      displayName = 'User Name Bussines';
      email = '';
      notifyListeners();
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  /// Allows manual refresh of user data (optional)
  Future<void> refreshUser() async {
    await _authService.currentUser?.reload();
    await _loadUserData();
  }
}

