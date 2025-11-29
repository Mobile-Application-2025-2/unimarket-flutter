import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton repository for managing user session persistence
/// Handles offline session resume and token expiration
class SessionRepository {
  // --- Singleton ---
  static final SessionRepository _instance = SessionRepository._internal();
  factory SessionRepository() => _instance;
  SessionRepository._internal();

  final _auth = FirebaseAuth.instance;
  static const _kIdTokenExpiry = 'id_token_expiry';

  /// Guardar expiración del token (llamar tras login exitoso con red)
  Future<void> saveTokenExpiry() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final res = await user.getIdTokenResult(true); // fuerza refresh online
      final exp = res.expirationTime;
      if (exp != null) {
        final sp = await SharedPreferences.getInstance();
        await sp.setInt(_kIdTokenExpiry, exp.millisecondsSinceEpoch);
      }
    } catch (_) {/* noop */}
  }

  /// ¿Hay sesión válida localmente para permitir modo lectura offline?
  Future<bool> hasValidLocalSessionOffline() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(_kIdTokenExpiry);
    if (ms == null) return false;

    return DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(ms));
  }
}
