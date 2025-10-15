class CategoryTypePopularity {
  final String type;
  final int totalSelections;

  CategoryTypePopularity({required this.type, required this.totalSelections});

  factory CategoryTypePopularity.fromMap(Map<String, dynamic> m) {
    return CategoryTypePopularity(
      type: (m['type'] ?? '').toString(),
      totalSelections: int.tryParse('${m['total_selections']}') ?? 0,
    );
  }
}
