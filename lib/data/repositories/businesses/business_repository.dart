import 'package:unimarket/utils/result.dart';
import 'package:unimarket/domain/models/business/business.dart';

abstract class BusinessRepository {
  Future<Result<List<Business>>> getBusinessList();
// Future<Result<Product>> getBooking(int id);
// Future<Result<void>> createBooking(Product booking);
// Future<Result<void>> delete(int id);
}
