import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:unimarket/domain/models/products/product.dart';
import 'package:unimarket/utils/command.dart';
import 'package:unimarket/utils/result.dart';

class HomeBuyerViewModel extends ChangeNotifier {
  HomeBuyerViewModel({
    required ProductRepository productRepository,
  }):  _productRepository = productRepository {
    load = Command0(_load)..execute();
  }

  late Command0 load;
  final ProductRepository _productRepository;
  final _log = Logger('HomeBuyerViewModel');

  List<Product> _products = [];

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  UnmodifiableListView<Product> get categories => UnmodifiableListView(_products);

  UnmodifiableListView<Product> get filteredCategories {
    if (_searchQuery.isEmpty) return UnmodifiableListView(_products);

    final categoriesFilteredByName = _products
        .where((category) {
            String copy = category.name.toLowerCase();
            String name = copy;
            List<List<String>> replaces = [
              ['á', 'a'],
              ['é', 'e'],
              ['í', 'i'],
              ['ó', 'o'],
              ['ú', 'u'],
            ];

            for (var replace in replaces) {
              copy = copy.replaceAll(replace[0], replace[1]);
            }

            return name.contains(_searchQuery.toLowerCase()) || copy.contains(_searchQuery.toLowerCase());
        }).toSet();

    return UnmodifiableListView(categoriesFilteredByName.toList());
  }

  Future<Result> _load() async {
    try {
      final result = await _productRepository.getProductsList();

      switch (result) {
        case Ok<List<Product>>():
          _products = result.value;
          notifyListeners();
        case Error<List<Product>>():
          _log.warning("Failed to load products", result.error);
      }

      return result;
    }
    finally {
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
