import 'package:unimarket/data/daos/order_dao.dart';
import 'package:unimarket/data/models/order_collection.dart';
import 'package:unimarket/data/repositories/orders/order_repository.dart';
import 'package:unimarket/domain/models/order/order.dart';

import 'package:unimarket/utils/result.dart';


class OrderRepositoryFirestore implements OrderRepository {
  OrderRepositoryFirestore({required OrderDao orderDao}): _orderDao = orderDao;

  final OrderDao  _orderDao;

  @override
  Future<Result<void>> createOrders(List<Order> orders) {
    // _orderDao.createNewOrder();
    print("Orders received: $orders in repository");

    for (var order in orders) {
      final orderMap = order.toJson();
      final id = orderMap['id'];
      orderMap.remove('id');
      _orderDao.createNewOrder(
        OrderCollection.fromFirestore(id, orderMap)
      );
    }

    return Future.value(Result.ok(null));
  }

  @override
  Future<Result<List<Order>>> getOrdersListBySellerId(String id) {
    // TODO: implement getOrdersListBySellerId
    throw UnimplementedError();
  }

}
