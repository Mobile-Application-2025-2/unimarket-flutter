class Category {
  final String id;
  final String name;
  final String type;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int selectionCount;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.selectionCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String, // Usando el nombre correcto del campo
      image: json['image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      selectionCount: json['selection_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type, // Usando el nombre correcto del campo
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'selection_count': selectionCount,
    };
  }

  // Método para obtener el icono basado en el tipo
  String get iconName {
    switch (type.toLowerCase()) {
      case 'tutoria':
        return 'school';
      case 'papeleria':
        return 'content_cut';
      case 'comida':
        return 'restaurant';
      case 'emprendimiento':
        return 'store';
      default:
        return 'shopping_bag';
    }
  }
}
