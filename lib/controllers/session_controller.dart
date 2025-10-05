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

  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Normalize email
    final normalizedEmail = email.trim().toLowerCase();
    
    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(normalizedEmail)) {
      throw AuthException('Please enter a valid email');
    }

    // Validate password
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
      
      // Cache user data in UserSession
      UserSession.instance.setUser(userModel.toUserSession());
      
      return userModel;
    } on AuthException {
      rethrow; // Re-throw AuthException to preserve original error details
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
    // Normalize email
    final normalizedEmail = email.trim().toLowerCase();
    
    // Validate inputs
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
      
      // Cache user data in UserSession
      UserSession.instance.setUser(userModel.toUserSession());
      
      return userModel;
    } on AuthException {
      rethrow; // Re-throw AuthException to preserve original error details
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    // Normalize email
    final normalizedEmail = email.trim().toLowerCase();
    
    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(normalizedEmail)) {
      throw AuthException('Please enter a valid email');
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(normalizedEmail);
    } on AuthException {
      rethrow; // Re-throw AuthException to preserve original error details
    } catch (e) {
      throw AuthException('An unexpected error occurred');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // Clear cached user data
      UserSession.instance.clear();
    } catch (e) {
      throw AuthException('Failed to sign out');
    }
  }

  /// Get current authenticated user
  UserModel? currentUser() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;
      
      return UserModel.fromAuth(user);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is currently logged in
  bool get isLoggedIn {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
