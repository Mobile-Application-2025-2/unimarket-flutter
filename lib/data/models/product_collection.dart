class ProductCollection {
  final String id;
  final String business;
  final String category;
  final List<String> comments;
  final String description;
  final String image;
  final String name;
  final double price;
  final double rating;

  ProductCollection({
    required this.id,
    required this.business,
    required this.category,
    required this.comments,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
  });

  factory ProductCollection.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductCollection(
      id: id,
      business: data['business'] ?? '',
      category: data['category'] ?? '',
      comments: List<String>.from(data['comments'] ?? []),
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      price: double.tryParse(data['price'].toString()) ?? 0,
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : (data['rating'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'business': business,
      'category': category,
      'comments': comments,
      'description': description,
      'image': image,
      'name': name,
      'price': price,
      'rating': rating,
    };
  }
}
