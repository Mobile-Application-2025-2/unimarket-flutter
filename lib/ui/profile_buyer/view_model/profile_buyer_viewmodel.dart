import 'package:flutter/foundation.dart';
import 'package:unimarket/utils/singleton.dart';
import 'package:unimarket/data/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/services/cache_service.dart';

class ProfileBuyerViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = Singleton<FirebaseAuthService>().instance;
  final CacheService _cache = Singleton<CacheService>().instance;

  String displayName = '';
  String email = '';
  bool loading = true;

  ProfileBuyerViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      displayName = user.displayName ?? user.email?.split('@').first ?? 'User';
      email = user.email ?? '';
    } else {
      displayName = 'Guest';
      email = '';
    }
    loading = false;
    notifyListeners();
  }

  /// Signs out the user from FirebaseAuth and clears cache
  Future<void> logout() async {
    try {
      await _authService.signOut();
      await _cache.clearSession();
      displayName = 'User Name Buyer';
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


