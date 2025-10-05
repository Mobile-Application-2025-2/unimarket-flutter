import 'package:flutter/foundation.dart';
import '../../data/repositories/category_repository.dart';
import '../../models/category.dart' as local;

class CategoriesController extends ChangeNotifier {
  final CategoryRepository repo;
  CategoriesController(this.repo);

  List<local.Category> items = [];
  bool loading = false;
  String? error;

  Future<void> load({int limit = 50}) async {
    loading = true; error = null; notifyListeners();
    try {
      items = await repo.getAll(limit: limit);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }
}
