import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/category.dart';
import 'category_repository.dart';

class CategoryRepositorySupabase implements CategoryRepository {
  final SupabaseClient client;
  final String table;
  CategoryRepositorySupabase(this.client, {this.table = 'categories'});

  @override
  Future<List<Category>> getAll({int limit = 50}) async {
    final res = await client.from(table).select().order('selection_count', ascending: false).limit(limit);
    return (res as List).map((e) => Category.fromMap(e)).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final res = await client.from(table).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Category.fromMap(res);
  }

  @override
  Future<String> create(Category category) async {
    final inserted = await client.from(table).insert(category.toMap()).select().single();
    return inserted['id'] as String;
  }

  @override
  Future<void> update(Category category) async {
    await client.from(table).update(category.toMap()).eq('id', category.id);
  }

  @override
  Future<void> delete(String id) async {
    await client.from(table).delete().eq('id', id);
  }
}
