class Category {
  final String id;
  final String name;
  final String type; // enum as string
  final String image;
  final int selectionCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.selectionCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      image: (map['image'] ?? '') as String,
      selectionCount: (map['selection_count'] ?? 0) is int
          ? map['selection_count'] as int
          : int.tryParse('${map['selection_count'] ?? 0}') ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'image': image,
    'selection_count': selectionCount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
