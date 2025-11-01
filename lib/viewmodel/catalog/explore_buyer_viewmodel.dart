import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/category.dart' as data;
import '../../model/catalog/entities/category_popularity.dart';
// TODO: Remove PopularityService dependency (Supabase-related)
// import '../../model/shared/services/popularity_service.dart';

class ExploreBuyerViewModel extends ChangeNotifier {
  // TODO: Reconnect this ViewModel with Firebase later
  // final PopularityService _popularityService;

  ExploreBuyerViewModel(/* this._popularityService */) {
    loadCategories();
  }

  // State
  List<data.Category> _categories = [];
  List<data.Category> _filteredCategories = [];
  String _selectedCategoryType = 'Todos';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Suggestions
  List<CategoryPopularity> _suggestions = [];
  bool _loadingSuggestions = false;
  String? _errorSuggestions;

  // Getters
  List<data.Category> get categories => _categories;
  List<data.Category> get filteredCategories => _filteredCategories;
  String get selectedCategoryType => _selectedCategoryType;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Suggestions getters
  List<CategoryPopularity> get suggestions => _suggestions;
  bool get loadingSuggestions => _loadingSuggestions;
  String? get errorSuggestions => _errorSuggestions;

  // Category types for filter
  List<String> get categoryTypes {
    final types = _categories.map((cat) => cat.type).toSet().toList();
    types.insert(0, 'Todos');
    return types;
  }

  // Methods
  Future<void> loadCategories() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Reconnect to Firebase/Firestore for loading categories
      // For now, using empty list
      _categories = [];
      _applyFilters();
    } catch (e) {
      _error = 'Error loading categories: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadSuggestions() async {
    _setLoadingSuggestions(true);
    _clearErrorSuggestions();

    try {
      // TODO: Reconnect to Firebase/Firestore for loading suggestions
      _suggestions = [];
    } catch (e) {
      _errorSuggestions = 'Error loading suggestions: $e';
    } finally {
      _setLoadingSuggestions(false);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void selectCategoryType(String type) {
    _selectedCategoryType = type;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredCategories = _categories.where((category) {
      final matchesSearch = _searchQuery.isEmpty ||
          category.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedCategoryType == 'Todos' ||
          category.type == _selectedCategoryType;
      return matchesSearch && matchesType;
    }).toList();
  }

  Future<void> refresh() async {
    await loadCategories();
    await loadSuggestions();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void clearErrorSuggestions() {
    _clearErrorSuggestions();
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingSuggestions(bool loading) {
    _loadingSuggestions = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _clearErrorSuggestions() {
    _errorSuggestions = null;
  }
}
