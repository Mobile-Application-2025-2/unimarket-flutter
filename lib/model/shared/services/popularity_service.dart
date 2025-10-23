import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/category_popularity.dart';

class PopularityService {
  final SupabaseClient _client;

  PopularityService(this._client);

  Future<List<CategoryTypePopularity>> getPopularCategories() async {
    try {
      final response = await _client
          .from('v_category_selection_by_type')
          .select();

      return (response as List)
          .map((json) => CategoryTypePopularity.fromMap(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching popular categories: $e');
    }
  }
}
