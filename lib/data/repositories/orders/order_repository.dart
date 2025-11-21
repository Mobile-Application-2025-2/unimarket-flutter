import 'package:unimarket/domain/models/order/order.dart';
import 'package:unimarket/utils/result.dart';

abstract class OrderRepository {
  Future<Result<List<Order>>> getOrdersListBySellerId(String id);
  Future<Result<void>> createOrders(List<Order> orders);
}
