import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/models/business_collection.dart';
import 'package:unimarket/data/models/orders_collection.dart';
import 'package:unimarket/utils/result.dart';

class OrderDao {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('orders');

  /*
  Future<Result<List<OrderCollection>>> getAllOrders() async {
    try {
      final querySnapshot = await _collection.get();
      final ordersCollection = querySnapshot.docs.map((doc) {
        return OrderCollection.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      });

      return Result.ok(ordersCollection.toList());
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Stream<List<BusinessCollection>> getssesStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BusinessCollection.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }*/

  Future<void> createNewOrder(OrderCollection order) async {
    await _collection.doc(order.id).set(order.toMap());
  }
}
