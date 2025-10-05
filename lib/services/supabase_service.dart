import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Obtiene el usuario actual autenticado
  static User? get currentUser => client.auth.currentUser;
  
  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => currentUser != null;
  
  /// Cierra sesión del usuario actual
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  /// Obtiene datos de una tabla específica
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final response = await client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }
  
  /// Inserta datos en una tabla específica
  static Future<Map<String, dynamic>> insertData(String table, Map<String, dynamic> data) async {
    final response = await client.from(table).insert(data).select().single();
    return response;
  }
  
  /// Actualiza datos en una tabla específica
  static Future<Map<String, dynamic>> updateData(String table, Map<String, dynamic> data, String id) async {
    final response = await client.from(table).update(data).eq('id', id).select().single();
    return response;
  }
  
  /// Elimina datos de una tabla específica
  static Future<void> deleteData(String table, String id) async {
    await client.from(table).delete().eq('id', id);
  }
  
  /// Obtiene categorías ordenadas por selection_count descendente
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from('categories')
        .select()
        .order('selection_count', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
