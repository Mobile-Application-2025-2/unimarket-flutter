class Singleton<T> {
  static final Map<Type, dynamic> _instances = {};

  static void register<T extends Object>(T instance) {
    _instances[T] = instance;
  }

  T get instance {
    if (_instances[T] == null) {
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

