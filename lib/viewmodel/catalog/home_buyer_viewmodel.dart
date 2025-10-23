import 'package:flutter/foundation.dart';

import '../../model/shared/services/popularity_service.dart';
import '../../models/category_popularity.dart';

class HomeBuyerViewModel extends ChangeNotifier {
  final PopularityService _popularityService;

  HomeBuyerViewModel(this._popularityService) {
    init();
  }

  // State
  bool _isLoading = false;
  String? _errorMessage;
  List<CategoryTypePopularity> _categories = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  List<VentureCard> _ventureCards = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryTypePopularity> get categories => _categories;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<VentureCard> get ventureCards => _ventureCards;

  // Derived getters
  bool get hasResults => _ventureCards.isNotEmpty;
  List<String> get categoryTypes => ['Todos', 'Comida', 'Papeleria', 'Tutorias', 'Servicios'];

  // Methods
  Future<void> init() async {
    _setLoading(true);
    _clearError();

    try {
      // Load popular categories
      _categories = await _popularityService.getPopularCategories();
      
      // Load mock venture cards
      _loadMockVentureCards();
    } catch (e) {
      _setError('Error loading data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterVentureCards();
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _filterVentureCards();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'Todos';
    _filterVentureCards();
    notifyListeners();
  }

  Future<void> refreshData() async {
    await init();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Private methods
  void _loadMockVentureCards() {
    _ventureCards = [
      VentureCard(
        imageUrl: 'https://picsum.photos/seed/uniwok/900/600',
        title: 'HJA WOK Parrilla Asiática',
        subtitle: 'Carne · Bowl · PAD THAI · Hamburguesa',
        rating: 4.0,
        comments: 124,
        isFavorite: false,
        category: 'Comida',
      ),
      VentureCard(
        imageUrl: 'https://picsum.photos/seed/magenta/900/600',
        title: 'Magenta',
        subtitle: 'Tacos · Burritos · Nachos · Quesadillas',
        rating: 4.0,
        comments: 124,
        isFavorite: true,
        category: 'Comida',
      ),
      VentureCard(
        imageUrl: 'https://picsum.photos/seed/papeleria/900/600',
        title: 'Papelería Universitaria',
        subtitle: 'Cuadernos · Lápices · Calculadoras · Libros',
        rating: 4.5,
        comments: 89,
        isFavorite: false,
        category: 'Papeleria',
      ),
      VentureCard(
        imageUrl: 'https://picsum.photos/seed/tutoria/900/600',
        title: 'Tutorías Matemáticas',
        subtitle: 'Cálculo · Álgebra · Estadística · Física',
        rating: 4.8,
        comments: 156,
        isFavorite: true,
        category: 'Tutorias',
      ),
    ];
    _filterVentureCards();
  }

  void _filterVentureCards() {
    // This would be implemented with actual filtering logic
    // For now, we'll just return all cards as the mock data is static
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}

// Data model for venture cards
class VentureCard {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double rating;
  final int comments;
  final bool isFavorite;
  final String category;

  VentureCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.comments,
    required this.isFavorite,
    required this.category,
  });
}
