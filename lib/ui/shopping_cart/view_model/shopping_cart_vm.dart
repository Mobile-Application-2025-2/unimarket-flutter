import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:unimarket/data/repositories/orders/order_repository.dart';
import 'package:unimarket/domain/models/order/order.dart';
import 'package:unimarket/domain/models/products/product.dart';
import 'package:uuid/uuid.dart';

class ShoppingCartViewModel extends ChangeNotifier {
  ShoppingCartViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  final OrderRepository _orderRepository;

  final List<Product> _cartItems = [];
  final Map<String, int> _itemCounts = {};
  int _total = 0;
  String paymentMethod = "";

  UnmodifiableListView<Product> get cartItems =>
      UnmodifiableListView(_cartItems);

  bool addToCart(Product product) {
    if (_itemCounts.containsKey(product.id)) {
      return false;
    }

    _cartItems.add(product);
    _total += product.price.toInt();
    _itemCounts[product.id] = 1;
    notifyListeners();

    return true;
  }

  makeOrders() {
    Map<String, Order> orders = {};

    for (var item in _cartItems) {
      final business = item.business;
      final count = _itemCounts[item.id]!;

      if (orders.containsKey(business)) {
        final prev = orders[business]!;

        final newProducts = [...prev.products, item.id];
        final newUnits = [...prev.units, count];

        orders[business] = prev.copyWith(
          products: newProducts,
          units: newUnits,
        );
      } else {
        orders[business] = Order(
          id: Uuid().v4().toString(),
          businessId: business,
          products: [item.id],
          units: [count],
          userId: '',
          createdAt: DateTime.timestamp(),
        );
      }
    }

    _orderRepository.createOrders(orders.values.toList());

    _cartItems.clear();
    _itemCounts.clear();
    notifyListeners();
  }

  getCounts(String id) => _itemCounts[id];

  removeFromCart(Product product) {
    _cartItems.remove(product);
    _total -= product.price.toInt();
    _itemCounts.remove(product.id);
    notifyListeners();
  }

  changeProductUnit(String action, Product product) {
    final String id = product.id;
    final int price = product.price.toInt();

    if (action == "INCREASE") {
      _itemCounts[id] = _itemCounts[id]! + 1;
      _total += price;
    } else if(action == "DECREASE") {
      if (_itemCounts[id]! - 1 < 1) return;

      _itemCounts[id] = _itemCounts[id]! - 1;
      _total -= price;
    }

    notifyListeners();
  }

  int get total {
    _total = 0;
    for (var item in _cartItems) {
      _total += item.price.toInt() * _itemCounts[item.id]!;
    }
    return _total;
  }
}
