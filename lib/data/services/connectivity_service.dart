import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Singleton service for monitoring network connectivity status
/// Provides reactive stream of online/offline changes
class ConnectivityService {
  // --- Singleton ---
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal() {
    _init();
  }

  final _controller = StreamController<bool>.broadcast();
  bool _online = true;
  StreamSubscription? _sub;

  Future<void> _init() async {
    // Estado inicial
    final first = await Connectivity().checkConnectivity();
    _online = first.contains(ConnectivityResult.none) == false;
    _controller.add(_online);

    // Suscripción reactiva
    _sub = Connectivity().onConnectivityChanged.listen((r) {
      final nowOnline = r.contains(ConnectivityResult.none) == false;
      if (nowOnline != _online) {
        _online = nowOnline;
        _controller.add(_online);
      }
    });
  }

  bool get isOnline => _online;
  Stream<bool> get online$ => _controller.stream;

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
