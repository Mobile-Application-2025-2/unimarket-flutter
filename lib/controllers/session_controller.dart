import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../core/user_session.dart';

class SessionController {
  static final SessionController _instance = SessionController._internal();
  
  factory SessionController() {
    return _instance;
  }
  
  SessionController._internal();

  static SessionController get instance => _instance;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(normalizedEmail)) {
      throw AuthException('Please enter a valid email');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Invalid login credentials');
      }

      final userModel = UserModel.fromAuth(response.user!);
      
      UserSession.instance.setUser(userModel.toUserSession());
      
      return userModel;
    } on AuthException {
      rethrow; 
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  /// Sign up with user details
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String type,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    
    if (name.trim().isEmpty) {
      throw AuthException('Please enter your name');
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(normalizedEmail)) {
      throw AuthException('Please enter a valid email');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    if (!['buyer', 'deliver', 'business'].contains(type)) {
      throw AuthException('Please select a valid account type');
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {
          'name': name.trim(),
          'type': type,
        },
      );

      if (response.user == null) {
        throw AuthException('Account creation failed');
      }

      final userModel = UserModel.fromAuth(response.user!);
      
      UserSession.instance.setUser(userModel.toUserSession());
      
      return userModel;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  Future<void> resetPassword(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(normalizedEmail)) {
      throw AuthException('Please enter a valid email');
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(normalizedEmail);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      UserSession.instance.clear();
    } catch (e) {
      throw AuthException('Failed to sign out');
    }
  }

  UserModel? currentUser() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;
      
      return UserModel.fromAuth(user);
    } catch (e) {
      return null;
    }
  }

  bool get isLoggedIn {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
