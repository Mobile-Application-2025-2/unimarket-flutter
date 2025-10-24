import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/entities/auth_user.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabase;
  final StreamController<AppUser?> _controller = StreamController<AppUser?>.broadcast();

  AuthService(this._supabase) {
    _supabase.onAuthStateChange.listen((event) {
      final session = event.session;
      final user = session?.user;
      _controller.add(user == null ? null : AppUser.fromSupabaseUser(user));
    });
  }

  Stream<AppUser?> get onAuthStateChanged => _controller.stream;

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user == null) {
      throw AuthException('Invalid login credentials');
    }
    
    return AppUser.fromSupabaseUser(response.user!);
  }

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
    required String type,
  }) async {
    final response = await _supabase.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'type': type,
      },
    );
    
    if (response.user == null) {
      throw AuthException('Failed to create account');
    }
    
    return AppUser.fromSupabaseUser(response.user!);
  }

  Future<void> signOut() async {
    await _supabase.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _supabase.resetPassword(email: email);
  }

  AppUser? get currentUser {
    final user = _supabase.currentUser;
    return user == null ? null : AppUser.fromSupabaseUser(user);
  }

  bool get isLoggedIn => currentUser != null;

  void dispose() {
    _controller.close();
  }
}
