import 'package:flutter/material.dart';
import '../../../data/models/category.dart';
import '../../../services/supabase_service.dart';

class ExploreBuyerController extends ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  String _selectedCategoryType = 'Todos';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Category> get categories => _categories;
  List<Category> get filteredCategories => _filteredCategories;
  String get selectedCategoryType => _selectedCategoryType;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Tipos únicos de categorías para el filtro
  List<String> get categoryTypes {
    final types = _categories.map((cat) => cat.type).toSet().toList();
    types.insert(0, 'Todos');
    return types;
  }

  ExploreBuyerController() {
    loadCategories();
  }

  /// Carga las categorías desde Supabase
  Future<void> loadCategories() async {
    try {
      _setLoading(true);
      _clearError();
      
      final response = await SupabaseService.getCategories();
      _categories = response.map((json) => Category.fromJson(json)).toList();
      
      // Aplicar filtro actual
      _applyFilter();
      
    } catch (e) {
      _setError('Error al cargar categorías: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Filtra las categorías por tipo
  void filterByType(String type) {
    _selectedCategoryType = type;
    _applyFilter();
    notifyListeners();
  }

  /// Actualiza la consulta de búsqueda
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase().trim();
    _applyFilter();
    notifyListeners();
  }

  /// Limpia la búsqueda
  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
    notifyListeners();
  }

  /// Aplica el filtro a las categorías
  void _applyFilter() {
    List<Category> filtered = List.from(_categories);

    // Filtrar por tipo de categoría
    if (_selectedCategoryType != 'Todos') {
      filtered = filtered.where((cat) => cat.type == _selectedCategoryType).toList();
    }

    // Filtrar por búsqueda (solo si hay consulta de búsqueda)
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((cat) => 
        cat.name.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    _filteredCategories = filtered;
  }

  /// Actualiza el contador de selección de una categoría
  Future<void> updateSelectionCount(String categoryId) async {
    try {
      final category = _categories.firstWhere((cat) => cat.id == categoryId);
      final updatedData = {
        'selection_count': category.selectionCount + 1,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      await SupabaseService.updateData('categories', updatedData, categoryId);
      
      // Actualizar localmente
      final updatedCategory = Category(
        id: category.id,
        name: category.name,
        type: category.type,
        image: category.image,
        createdAt: category.createdAt,
        updatedAt: DateTime.now(),
        selectionCount: category.selectionCount + 1,
      );
      
      final index = _categories.indexWhere((cat) => cat.id == categoryId);
      if (index != -1) {
        _categories[index] = updatedCategory;
        _applyFilter();
        notifyListeners();
      }
    } catch (e) {
      _setError('Error al actualizar categoría: ${e.toString()}');
    }
  }

  /// Recarga las categorías
  Future<void> refresh() async {
    await loadCategories();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
