import '../../models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll({int limit = 50});
  Future<Category?> getById(String id);
  Future<String> create(Category category);
  Future<void> update(Category category);
  Future<void> delete(String id);
}
