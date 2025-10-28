import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:unimarket/domain/models/categories/category.dart';

class HomeBuyerViewModel extends ChangeNotifier {
  HomeBuyerViewModel();

  List<Category> _categories = [
    new Category(
      id: 'cat1',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Matemáticas Avanzadas',
      type: 'Tutoria',
    ),
    new Category(
      id: 'cat2',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Cuadernos y Libretas',
      type: 'Funkos',
    ),
    new Category(
      id: 'cat3',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Café Orgánico Especial',
      type: 'Comida',
    ),
    new Category(
      id: 'cat4',
      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmsIy7X7phPyQGZO9Hvi-V_vM52GlDjDu2uQ&s',
      name: 'Servicios de Impresión',
      type: 'Emprendimiento',
    ),
    new Category(
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

  UnmodifiableListView<String> get uniqueCategories {
    List<String> categoryTypes = [
      "Todos",
      ...categories.map((category) => category.type)
        .toList()
        .toSet()
    ];

    return UnmodifiableListView(categoryTypes);
  }

  UnmodifiableListView<Category> get filteredCategories {
    if (_searchQuery.isEmpty && _selectedCategory == 'Todos') return UnmodifiableListView(_categories);

    final filteredCategories = _categories
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

    final filteredByCategoryType = _selectedCategory.isEmpty
        ? filteredCategories
        : filteredCategories.where((category) => category.type == _selectedCategory).toSet();

    if (_searchQuery.isEmpty && _selectedCategory.isNotEmpty) {
      return UnmodifiableListView(filteredByCategoryType);
    }

    if (_searchQuery.isNotEmpty && _selectedCategory.isEmpty) {
      return UnmodifiableListView(filteredCategories);
    }

    return UnmodifiableListView(filteredCategories.intersection(filteredByCategoryType));
  }

  Future<void> _load() async {
    try {
      _categories = _categories;
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
