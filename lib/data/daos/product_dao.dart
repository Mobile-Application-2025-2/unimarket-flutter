import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/models/product_collection.dart';
import 'package:unimarket/utils/result.dart';

class ProductDao {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductCollection product) async {
    await _collection.doc(product.id).set(product.toMap());
  }

  Future<Result<List<ProductCollection>>> getAllProducts() async {
    try {
      final querySnapshot = await _collection.get();
      final productCollection = querySnapshot.docs.map((doc) {
        return ProductCollection.fromFirestore(
            doc.id, doc.data() as Map<String, dynamic>);
      });

      return Result.ok(productCollection.toList());
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<List<ProductCollection>> getProductsByCategory(String category) async {
    final querySnapshot =
    await _collection.where('category', isEqualTo: category).get();
    return querySnapshot.docs.map((doc) {
      return ProductCollection.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<ProductCollection?> getProductById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ProductCollection.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateProduct(ProductCollection product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<ProductCollection>> getProductsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductCollection.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
