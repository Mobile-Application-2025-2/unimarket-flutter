import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/app_user.dart';
import 'user_repository.dart';

class UserRepositorySupabase implements UserRepository {
  final SupabaseClient client;
  final String table;
  UserRepositorySupabase(this.client, {this.table = 'users'});

  @override
  Future<List<AppUser>> getAll({int limit = 100}) async {
    final res = await client.from(table).select().order('created_at', ascending: false).limit(limit);
    return (res as List).map((e) => AppUser.fromMap(e)).toList();
  }

  @override
  Future<AppUser?> getById(String id) async {
    final res = await client.from(table).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return AppUser.fromMap(res);
  }

  @override
  Future<AppUser?> getByEmail(String email) async {
    final res = await client.from(table).select().ilike('email', email).maybeSingle();
    if (res == null) return null;
    return AppUser.fromMap(res);
  }

  @override
  Future<String> create(AppUser user) async {
    final inserted = await client.from(table).insert(user.toMap()).select().single();
    return inserted['id'] as String;
  }

  @override
  Future<void> update(AppUser user) async {
    await client.from(table).update(user.toMap()).eq('id', user.id);
  }

  @override
  Future<void> delete(String id) async {
    await client.from(table).delete().eq('id', id);
  }
}
