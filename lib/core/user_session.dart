class UserSession {
  // Singleton implementation
  static final UserSession _instance = UserSession._internal();
  
  factory UserSession() {
    return _instance;
  }
  
  UserSession._internal();
  
  static UserSession get instance => _instance;
  
  // User data properties
  String? id;
  String? email;
  String? name;
  String? type;
  
  /// Set user data from authentication response
  void setUser(Map<String, dynamic> userData) {
    id = userData['id'];
    email = userData['email'];
    name = userData['name'];
    type = userData['type'];
  }
  
  /// Clear user data (logout)
  void clear() {
    id = null;
    email = null;
    name = null;
    type = null;
  }
  
  /// Check if user is logged in
  bool get isLoggedIn => id != null;
  
  /// Get user display name with fallback
  String get displayName => name ?? email ?? 'User';
}
