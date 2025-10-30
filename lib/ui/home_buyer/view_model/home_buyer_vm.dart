import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:unimarket/domain/models/categories/category.dart';
import 'package:unimarket/utils/command.dart';
import 'package:unimarket/utils/result.dart';

class HomeBuyerViewModel extends ChangeNotifier {
  HomeBuyerViewModel() {
    load = Command0(_load)..execute();
  }

  late Command0 load;

  final List<Category> _categories = [
    Category(
      id: 'cat1',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Matemáticas Avanzadas',
      type: 'Tutoria',
    ),
    Category(
      id: 'cat2',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Cuadernos y Libretas',
      type: 'Funkos',
    ),
    Category(
      id: 'cat3',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Café Orgánico Especial',
      type: 'Comida',
    ),
    Category(
      id: 'cat4',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Servicios de Impresión',
      type: 'Emprendimiento',
    ),
    Category(
      id: 'cat5',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Matematicas Avanzadas',
      type: 'Emprendimiento',
    ),
  ];

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String _selectedCategory = "Todos";
  String get selectedCategory => _selectedCategory;

  UnmodifiableListView<Category> get categories => UnmodifiableListView(_categories);

  // for the horizontal scroll view
  UnmodifiableListView<String> get uniqueCategories {
    List<String> categoryTypes = [
      "Todos",
      ...categories.map((category) => category.type)
        .toList()
        .toSet()
    ];

    return UnmodifiableListView(categoryTypes);
  }

  // for the vertical scroll view
  UnmodifiableListView<Category> get filteredCategories {
    if (_searchQuery.isEmpty && _selectedCategory == 'Todos') return UnmodifiableListView(_categories);

    final categoriesFilteredByName = _categories
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

    final categoriesFilteredByCategoryType = _selectedCategory.isEmpty
        ? categoriesFilteredByName
        : categoriesFilteredByName.where((category) => category.type == _selectedCategory).toSet();

    if(_selectedCategory == "Todos") {
      if (_searchQuery.isNotEmpty) {
        return UnmodifiableListView(_categories.toSet().intersection(categoriesFilteredByName));
      } else {
        return UnmodifiableListView(_categories);
      }
    } else {
      if (_searchQuery.isNotEmpty) {
        return UnmodifiableListView(categoriesFilteredByName.intersection(
            categoriesFilteredByCategoryType));
      } else {
        return UnmodifiableListView(categoriesFilteredByCategoryType);
      }
    }
  }

  Future<Result> _load() async {
    try {
      sleep(Duration(seconds: 1));
      return Result.ok(_categories);
    }
    finally {
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
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
