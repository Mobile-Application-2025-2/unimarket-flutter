class AppUser {
  final String id;
  final String name;
  final String email;
  final String type;      // enum as string: buyer/deliver
  final String idType;    // enum as string: id
  final String idNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.idType,
    required this.idNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      type: map['type'] as String,
      idType: map['id_type'] as String,
      idNumber: (map['id_number'] ?? '') as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'type': type,
    'id_type': idType,
    'id_number': idNumber,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
