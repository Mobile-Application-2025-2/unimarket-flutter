import 'package:unimarket/utils/result.dart';
import 'package:unimarket/domain/models/products/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProductsList();
  // Future<Result<Product>> getBooking(int id);
  // Future<Result<void>> createBooking(Product booking);
  // Future<Result<void>> delete(int id);
}
