import 'package:supabase_flutter/supabase_flutter.dart';
import '../../catalog/entities/category_popularity.dart';

class PopularityService {
  final SupabaseClient _client;

  PopularityService(this._client);

  Future<List<CategoryPopularity>> getPopularCategories() async {
    try {
      final response = await _client
          .from('v_category_selection_by_type')
          .select();

      return (response as List)
          .map((json) => CategoryPopularity.fromMap(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching popular categories: $e');
    }
  }
}
