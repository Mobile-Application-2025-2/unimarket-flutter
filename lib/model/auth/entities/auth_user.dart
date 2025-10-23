import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? type;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.type,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? type,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  factory AppUser.fromSupabaseUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'],
      type: user.userMetadata?['type'],
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'type': type,
    };
  }

  Map<String, dynamic> toUserSession() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'type': type,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ type.hashCode;
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, name: $name, type: $type)';
  }
}