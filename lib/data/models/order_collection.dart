import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCollection {
  final String id;
  final String businessId;
  final List<String> products;
  final List<int> units;
  final String userId;
  final DateTime createdAt;
  final String paymentMethod;

  OrderCollection({required this.id, required this.businessId, required this.products, required this.units, required this.userId, required this.createdAt, required this.paymentMethod});

  factory OrderCollection.fromFirestore(String id, Map<String, dynamic> data) {
    Timestamp? timestamp = data['date'] as Timestamp?;
    DateTime createdAt = timestamp?.toDate() ?? DateTime.now().toUtc();

    return OrderCollection(
      id: id,
      businessId: data['business_id'] ?? '',
      products: List.from(data['products'] ?? []),
      units: List.from(data['units'] ?? []),
      userId: data['user_id'] ?? '',
      createdAt: createdAt,
      paymentMethod: data['payment_method'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'business_id': businessId,
      'products': products,
      'units': units,
      'user_id': userId,
      'date': createdAt,
      'payment_method': paymentMethod
    };
  }

  @override
  String toString() {
    return 'OrderCollection(id: $id, businessId: $businessId, products: $products, units: $units, userId: $userId, createdAt: $createdAt, paymentMethod: $paymentMethod)';
  }
}
