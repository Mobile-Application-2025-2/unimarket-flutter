import 'package:unimarket/data/daos/order_dao.dart';
import 'package:unimarket/data/repositories/orders/order_repository.dart';
import 'package:unimarket/domain/models/order/order.dart';
import 'package:unimarket/domain/models/products/product.dart';

import 'package:unimarket/utils/result.dart';


class OrderRepositoryFirestore implements OrderRepository {
  OrderRepositoryFirestore({required OrderDao orderDao}): _orderDao = orderDao;

  final OrderDao  _orderDao;

  @override
  Future<Result<void>> createOrders(List<Product> products, Map<String, int> quantities) {
    // TODO: implement createOrders
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Order>>> getOrdersListBySellerId(String id) {
    // TODO: implement getOrdersListBySellerId
    throw UnimplementedError();
  }

}
