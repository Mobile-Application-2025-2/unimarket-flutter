import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService({
    required String url,
    required String anonKey,
  }) : client = SupabaseClient(url, anonKey);

  // Convenience getters
  GoTrueClient get auth => client.auth;
  RealtimeClient get realtime => client.realtime;

  // Authentication methods
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await auth.resetPasswordForEmail(email);
  }

  // User state
  User? get currentUser => auth.currentUser;
  Session? get currentSession => auth.currentSession;

  // Auth state changes
  Stream<AuthState> get onAuthStateChange => auth.onAuthStateChange;

  // Database operations
  PostgrestQueryBuilder from(String table) => client.from(table);
  
  // Initialize Supabase (static method for app initialization)
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}