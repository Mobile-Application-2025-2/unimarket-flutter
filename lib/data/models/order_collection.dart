import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCollection {
  final String id;
  final String businessId;
  final List<String> products;
  final List<int> units;
  final String userId;
  final DateTime createdAt;

  OrderCollection({required this.id, required this.businessId, required this.products, required this.units, required this.userId, required this.createdAt});

  factory OrderCollection.fromFirestore(String id, Map<String, dynamic> data) {
    Timestamp? timestamp = data['date'] as Timestamp?;
    DateTime createdAt = timestamp?.toDate() ?? DateTime.now().toUtc();

    return OrderCollection(
      id: id,
      businessId: data['business_id'] ?? '',
      products: List.from(data['products'] ?? []),
      units: List.from(data['units'] ?? []),
      userId: data['user_id'] ?? '',
      createdAt: createdAt
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessId': businessId,
      'products': products,
      'units': units,
      'userId': userId,
      'date': createdAt
    };
  }
}
