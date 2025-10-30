import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class ProductDao {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('products');

  /// Agrega un nuevo producto
  Future<void> addProduct(Product product) async {
    await _collection.doc(product.id).set(product.toMap());
  }

  /// Obtiene todos los productos
  Future<List<Product>> getAllProducts() async {
    final querySnapshot = await _collection.get();
    return querySnapshot.docs.map((doc) {
      return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    final querySnapshot =
    await _collection.where('category', isEqualTo: category).get();
    return querySnapshot.docs.map((doc) {
      return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  /// Obtiene un producto por ID
  Future<Product?> getProductById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Actualiza un producto existente
  Future<void> updateProduct(Product product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  /// Elimina un producto
  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }

  /// Stream en tiempo real (útil para ListView.builder reactivo)
  Stream<List<Product>> getProductsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
