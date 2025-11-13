import 'package:firebase_auth/firebase_auth.dart';
import 'package:unimarket/data/daos/order_dao.dart';
import 'package:unimarket/data/models/order_collection.dart';
import 'package:unimarket/data/repositories/orders/order_repository.dart';
import 'package:unimarket/data/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/domain/models/order/order.dart';

import 'package:unimarket/utils/result.dart';

class OrderRepositoryFirestore implements OrderRepository {
  OrderRepositoryFirestore({
    required OrderDao orderDao,
    required FirebaseAuthService firebaseAuthServiceAdapter,
  }) : _orderDao = orderDao,
       _firebaseAuthServiceAdapter = firebaseAuthServiceAdapter;

  final OrderDao _orderDao;
  final FirebaseAuthService _firebaseAuthServiceAdapter;

  @override
  Future<Result<void>> createOrders(List<Order> orders) {
    User user = _firebaseAuthServiceAdapter.currentUser!;
    String email = user.email!;

    for (var order in orders) {
      final orderMap = order.toJson();
      orderMap['business_id'] = orderMap['businessId'];
      orderMap['user_id'] = email;
      orderMap['payment_method'] = orderMap['paymentMethod'];

      _orderDao.createNewOrder(
        OrderCollection.fromFirestore(orderMap['id'], orderMap),
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
