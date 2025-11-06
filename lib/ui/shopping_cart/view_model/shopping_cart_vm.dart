import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/domain/models/products/product.dart';

class ShoppingCartViewModel extends ChangeNotifier {
  ShoppingCartViewModel({required ProductRepository productRepository})
    : _productRepository = productRepository {}

  final ProductRepository _productRepository;

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
