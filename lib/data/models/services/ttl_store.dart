import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service for managing TTL (Time-To-Live) of cached data
/// Stores last refresh timestamps and checks if data has expired
class TtlStore {
  // --- Singleton ---
  static final TtlStore _instance = TtlStore._internal();
  factory TtlStore() => _instance;
  TtlStore._internal();

  static const _kLastRefreshProducts = 'last_refresh_products';
  static const _kLastRefreshBusinesses = 'last_refresh_businesses';

  Future<DateTime?> _get(String key) async {
    final sp = await SharedPreferences.getInstance();
    final ms = sp.getInt(key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> _set(String key, DateTime t) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(key, t.millisecondsSinceEpoch);
  }

  Future<bool> isExpired(
    String key, {
    Duration ttl = const Duration(minutes: 15),
  }) async {
    final last = await _get(key);
    return last == null || DateTime.now().difference(last) > ttl;
  }

  Future<void> markRefreshed(String key) => _set(key, DateTime.now());

  // Helpers por colección
  Future<bool> productsExpired() => isExpired(_kLastRefreshProducts);
  Future<void> productsRefreshed() => markRefreshed(_kLastRefreshProducts);

  Future<bool> businessesExpired() => isExpired(_kLastRefreshBusinesses);
  Future<void> businessesRefreshed() => markRefreshed(_kLastRefreshBusinesses);
}
