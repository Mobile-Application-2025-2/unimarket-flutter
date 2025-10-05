import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? type;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.type,
  });

  /// Factory constructor to create UserModel from Supabase User
  factory UserModel.fromAuth(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'],
      type: user.userMetadata?['type'],
    );
  }

  /// Convert UserModel to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'type': type,
    };
  }

  /// Convert UserModel to UserSession format
  Map<String, dynamic> toUserSession() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ type.hashCode;
  }
}
