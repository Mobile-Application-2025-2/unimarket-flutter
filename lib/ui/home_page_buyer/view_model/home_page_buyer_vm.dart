import 'dart:collection';

import 'package:logging/logging.dart';

import 'package:flutter/cupertino.dart';
import 'package:unimarket/data/repositories/businesses/business_repository.dart';
import 'package:unimarket/domain/models/business/business.dart';
import 'package:unimarket/utils/command.dart';
import 'package:unimarket/utils/result.dart';

class HomePageBuyerViewModel extends ChangeNotifier {
  HomePageBuyerViewModel({
    required BusinessRepository businessRepository,
  }):  _businessRepository = businessRepository {
    load = Command0(_load)..execute();
  }

  late Command0 load;
  final BusinessRepository _businessRepository;
  final _log = Logger('HomeBuyerViewModel');

  List<Business> _businesses = [];

  String _selectedCategory = "Todos";
  String get selectedCategory => _selectedCategory;

  UnmodifiableListView<Business> get uniqueCategories => UnmodifiableListView(_businesses);

  UnmodifiableListView<String> get uniqueBusinessCategories {
    List<String> categoryTypes = [
      "Todos",
      ..._businesses.map((business) => business.categories)
          .toList()
          .expand((element) => element)
          .toSet()
    ];

    return UnmodifiableListView(categoryTypes);
  }

  UnmodifiableListView<Business> get filteredBusinesses {
    if (_selectedCategory == 'Todos') return UnmodifiableListView(_businesses);

    final categoriesFilteredByCategoryType = _businesses.where((business) => business.categories.contains(_selectedCategory)).toList();

    return UnmodifiableListView(categoriesFilteredByCategoryType);
  }

  Future<Result> _load() async {
    try {
      final result = await _businessRepository.getBusinessList();

      switch (result) {
        case Ok<List<Business>>():
          _businesses = result.value;
          notifyListeners();
        case Error<List<Business>>():
          _log.warning("Failed to load products", result.error);
      }

      return result;
    }
    finally {
      notifyListeners();
    }
  }

  void setSelectedCategory(String value) {
    if (value == _selectedCategory && value != 'Todos') {
      _selectedCategory = "Todos";
      notifyListeners();
      return;
    }

    _selectedCategory = value;
    notifyListeners();
  }
}
