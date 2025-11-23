import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _keySessionUid = 'session_uid';
  static const String _keySessionEmail = 'session_email';
  static const String _keySessionAccountType = 'session_account_type';
  static const String _keySessionDisplayName = 'session_display_name';
  static const String _keySessionRememberMe = 'session_remember_me';
  static const String _keySessionLastLoginAt = 'session_last_login_at';
  static const String _keyUiLastLoginEmail = 'ui_last_login_email';
  static const String _keyUiLastAccountType = 'ui_last_account_type';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save session metadata (no tokens)
  Future<void> saveSession({
    required String uid,
    required String email,
    required String accountType, // 'buyer' | 'deliver' | 'business'
    String? displayName,
    required bool rememberMe,
  }) async {
    if (_prefs == null) await init();
    
    await _prefs!.setString(_keySessionUid, uid);
    await _prefs!.setString(_keySessionEmail, email);
    await _prefs!.setString(_keySessionAccountType, accountType);
    if (displayName != null) {
      await _prefs!.setString(_keySessionDisplayName, displayName);
    }
    await _prefs!.setBool(_keySessionRememberMe, rememberMe);
    await _prefs!.setString(_keySessionLastLoginAt, DateTime.now().toIso8601String());
  }

  /// Clear all session data
  Future<void> clearSession() async {
    if (_prefs == null) await init();
    
    await _prefs!.remove(_keySessionUid);
    await _prefs!.remove(_keySessionEmail);
    await _prefs!.remove(_keySessionAccountType);
    await _prefs!.remove(_keySessionDisplayName);
    await _prefs!.remove(_keySessionRememberMe);
    await _prefs!.remove(_keySessionLastLoginAt);
  }

  // Session getters
  String? get cachedUid {
    return _prefs?.getString(_keySessionUid);
  }

  String? get cachedEmail {
    return _prefs?.getString(_keySessionEmail);
  }

  String? get cachedAccountType {
    return _prefs?.getString(_keySessionAccountType);
  }

  String? get cachedDisplayName {
    return _prefs?.getString(_keySessionDisplayName);
  }

  bool get rememberMe {
    return _prefs?.getBool(_keySessionRememberMe) ?? false;
  }

  DateTime? get lastLoginAt {
    final str = _prefs?.getString(_keySessionLastLoginAt);
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (_) {
      return null;
    }
  }

  // UI cache methods
  Future<void> setLastLoginEmail(String email) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_keyUiLastLoginEmail, email);
  }

  String? get lastLoginEmail {
    return _prefs?.getString(_keyUiLastLoginEmail);
  }

  Future<void> setLastChosenAccountType(String type) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_keyUiLastAccountType, type);
  }

  String? get lastChosenAccountType {
    return _prefs?.getString(_keyUiLastAccountType);
  }
}

