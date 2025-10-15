import 'package:supabase_flutter/supabase_flutter.dart';

class PopularityService {
  final SupabaseClient _client;
  PopularityService(this._client);

  Future<List<Map<String, dynamic>>> topTypes({int limit = 10}) async {
    final rows = await _client
        .from('v_category_selection_by_type')
        .select('type,total_selections')
        .order('total_selections', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(rows as List);
  }
}
