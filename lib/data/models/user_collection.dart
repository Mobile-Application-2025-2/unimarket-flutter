class UserCollection {
  final String id;             // Firebase UID
  final String name;
  final String email;
  final String accountType;    // 'buyer' | 'business'
  final bool emailVerified;
  final DateTime createdAt;

  const UserCollection({
    required this.id,
    required this.name,
    required this.email,
    required this.accountType,
    required this.emailVerified,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'accountType': accountType,
        'emailVerified': emailVerified,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  static UserCollection fromFirestore(String id, Map<String, dynamic> data) {
    return UserCollection(
      id: id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      accountType: (data['accountType'] as String?) ?? 'buyer',
      emailVerified: (data['emailVerified'] as bool?) ?? false,
      createdAt: DateTime.tryParse((data['createdAt'] as String?) ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}


