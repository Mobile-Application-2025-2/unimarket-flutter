import '../../models/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getAll({int limit = 100});
  Future<AppUser?> getById(String id);
  Future<AppUser?> getByEmail(String email);
  Future<String> create(AppUser user);
  Future<void> update(AppUser user);
  Future<void> delete(String id);
}
