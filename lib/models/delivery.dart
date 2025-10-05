class Delivery {
  final String id;
  final String product;
  final String category;        // FK -> categories.id
  final DateTime time;
  final String addressDelivery;
  final String addressPickup;
  final double price;
  final String deliveryPerson;  // FK -> users.id
  final String buyerPerson;     // FK -> users.id
  final DateTime createdAt;
  final DateTime updatedAt;

  const Delivery({
    required this.id,
    required this.product,
    required this.category,
    required this.time,
    required this.addressDelivery,
    required this.addressPickup,
    required this.price,
    required this.deliveryPerson,
    required this.buyerPerson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'] as String,
      product: (map['product'] ?? '') as String,
      category: map['category'] as String,
      time: DateTime.parse(map['time'] as String),
      addressDelivery: (map['address_delivery'] ?? '') as String,
      addressPickup: (map['address_pickup'] ?? '') as String,
      price: double.tryParse('${map['price'] ?? 0}') ?? 0,
      deliveryPerson: map['delivery_person'] as String,
      buyerPerson: map['buyer_person'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'product': product,
    'category': category,
    'time': time.toIso8601String(),
    'address_delivery': addressDelivery,
    'address_pickup': addressPickup,
    'price': price,
    'delivery_person': deliveryPerson,
    'buyer_person': buyerPerson,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
