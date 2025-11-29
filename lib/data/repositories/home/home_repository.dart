import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/models/product_collection.dart';
import 'package:unimarket/data/models/business_collection.dart';
import 'package:unimarket/data/services/ttl_store.dart';

/// Repository for Home data with cache-then-network strategy
/// Uses Firestore's native offline persistence + TTL management
class HomeRepository {
  HomeRepository(this._db, this._ttl) 
    : _productDao = ProductDao(),
      _businessDao = BusinessDao();

  final FirebaseFirestore _db;
  final TtlStore _ttl;
  final ProductDao _productDao;
  final BusinessDao _businessDao;

  /// Watch products stream (cache-first via Firestore persistence)
  Stream<List<ProductCollection>> watchProducts() {
    return _productDao.getProductsStream();
  }

  /// Watch businesses stream (cache-first via Firestore persistence)
  Stream<List<BusinessCollection>> watchBusinesses() {
    return _businessDao.getBusinessesStream();
  }

  /// Refresh products from server (forces network fetch)
  Future<void> refreshProductsFromServer() async {
    try {
      final snap = await _db
          .collection('products')
          .get(const GetOptions(source: Source.server));

      // Access to "pin" data in local cache
      for (final _ in snap.docs) {/* no-op */}

      await _ttl.productsRefreshed();
    } catch (_) {
      // Log optional; don't break UI if it fails
    }
  }

  /// Refresh businesses from server (forces network fetch)
  Future<void> refreshBusinessesFromServer() async {
    try {
      final snap = await _db
          .collection('businesses')
          .get(const GetOptions(source: Source.server));

      for (final _ in snap.docs) {/* no-op */}

      await _ttl.businessesRefreshed();
    } catch (_) {}
  }
}
