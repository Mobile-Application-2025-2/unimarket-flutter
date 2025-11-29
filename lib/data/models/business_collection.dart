import 'address_property.dart';

class BusinessCollection {
  final AddressProperty address;
  final List<String> categories;
  final String logo;
  final String name;
  final List<String> products;
  final double rating;

  BusinessCollection({
    required this.address,
    required this.categories,
    required this.logo,
    required this.name,
    required this.products,
    required this.rating,
  });

  factory BusinessCollection.fromFirestore(String id, Map<String, dynamic> data) {
    List<String> categories = List<String>.from(data['categories']);
    List<String> mappedCategories = categories.map((category) {
      return category.substring(0, 1).toUpperCase() + category.substring(1);
    }).toList();

    return BusinessCollection(
      address: AddressProperty(
          direccion: data['address']['direccion'] ?? '',
          edificio: data['address']['edificio'] ?? '',
          local: data['address']['local'] ?? '',
          piso: data['address']['piso'] ?? '',
          salon: data['address']['salon'] ?? '',
      ),
      categories: mappedCategories,
      logo: data['logo'] ?? "",
      name: data['name'] ?? "",
      products: List<String>.from(data['products'] ?? []),
      rating: (data['rating'] is int)
          ? (data['rating'] as int).toDouble()
          : (data['rating'] ?? 0.0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'categories': categories,
      'logo': logo,
      'name': name,
      'products': products,
      'rating': rating,
    };
  }
}
