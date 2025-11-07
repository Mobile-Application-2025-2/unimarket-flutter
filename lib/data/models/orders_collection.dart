import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCollection {
  final String id;
  final String businessId;
  final String productId;
  final int units;
  final String userId;
  final DateTime createdAt;

  OrderCollection({required this.id, required this.businessId, required this.productId, required this.units, required this.userId, required this.createdAt});

  factory OrderCollection.fromFirestore(String id, Map<String, dynamic> data) {
    Timestamp? timestamp = data['created_at'] as Timestamp?;
    DateTime createdAt = timestamp?.toDate() ?? DateTime.now().toUtc();

    return OrderCollection(
      id: id,
      businessId: data['business_id'] ?? '',
      productId: data['product_id'] ?? '',
      units: data['units'] ?? 0,
      userId: data['user_id'] ?? '',
      createdAt: createdAt
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessId': businessId,
      'productId': productId,
      'units': units,
      'userId': userId,
      'date': createdAt
    };
  }
}
