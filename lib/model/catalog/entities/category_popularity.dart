class CategoryPopularity {
  final String type;
  final int totalSelections;

  const CategoryPopularity({
    required this.type,
    required this.totalSelections,
  });

  CategoryPopularity copyWith({
    String? type,
    int? totalSelections,
  }) {
    return CategoryPopularity(
      type: type ?? this.type,
      totalSelections: totalSelections ?? this.totalSelections,
    );
  }

  factory CategoryPopularity.fromJson(Map<String, dynamic> json) {
    return CategoryPopularity(
      type: (json['type'] ?? '').toString(),
      totalSelections: int.tryParse('${json['total_selections']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'total_selections': totalSelections,
    };
  }

  // Legacy support for fromMap method
  factory CategoryPopularity.fromMap(Map<String, dynamic> map) {
    return CategoryPopularity.fromJson(map);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryPopularity &&
        other.type == type &&
        other.totalSelections == totalSelections;
  }

  @override
  int get hashCode {
    return type.hashCode ^ totalSelections.hashCode;
  }

  @override
  String toString() {
    return 'CategoryPopularity(type: $type, totalSelections: $totalSelections)';
  }
}
