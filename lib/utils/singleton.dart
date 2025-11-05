class Singleton<T> {
  static final Map<Type, dynamic> _instances = {};

  /// Registers an already created instance of [T].
  static void register<T extends Object>(T instance) {
    _instances[T] = instance;
  }

  T get instance {
    if (_instances[T] == null) {
      // ignore: avoid_print
      print('[Singleton] Creating new instance of $T');
      _instances[T] = _createInstance<T>();
    }
    return _instances[T] as T;
  }

  static T _createInstance<T>() {
    throw UnimplementedError(
      'You must register an instance of $T using Singleton.register().',
    );
  }
}

