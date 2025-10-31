import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBuyerViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String displayName = '';
  String email = '';
  bool loading = true;

  ProfileBuyerViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
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

  /// Signs out the user from FirebaseAuth
  Future<void> logout() async {
    try {
      await _auth.signOut();
      displayName = 'User Name Buyer';
      email = '';
      notifyListeners();
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  /// Allows manual refresh of user data (optional)
  Future<void> refreshUser() async {
    await _auth.currentUser?.reload();
    await _loadUserData();
  }
}


