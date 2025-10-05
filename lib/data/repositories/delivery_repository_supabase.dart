import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/delivery.dart';
import 'delivery_repository.dart';

class DeliveryRepositorySupabase implements DeliveryRepository {
  final SupabaseClient client;
  final String table;
  DeliveryRepositorySupabase(this.client, {this.table = 'deliveries'});

  @override
  Future<List<Delivery>> getAll({int limit = 50}) async {
    final res = await client.from(table).select().order('created_at', ascending: false).limit(limit);
    return (res as List).map((e) => Delivery.fromMap(e)).toList();
  }

  @override
  Future<Delivery?> getById(String id) async {
    final res = await client.from(table).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return Delivery.fromMap(res);
    }

  @override
  Future<String> create(Delivery delivery) async {
    final inserted = await client.from(table).insert(delivery.toMap()).select().single();
    return inserted['id'] as String;
  }

  @override
  Future<void> update(Delivery delivery) async {
    await client.from(table).update(delivery.toMap()).eq('id', delivery.id);
  }

  @override
  Future<void> delete(String id) async {
    await client.from(table).delete().eq('id', id);
  }

  @override
  Future<List<Delivery>> getByBuyer(String buyerId, {int limit = 50}) async {
    final res = await client.from(table).select().eq('buyer_person', buyerId).order('created_at', ascending: false).limit(limit);
    return (res as List).map((e) => Delivery.fromMap(e)).toList();
  }

  @override
  Future<List<Delivery>> getByDeliveryPerson(String deliveryId, {int limit = 50}) async {
    final res = await client.from(table).select().eq('delivery_person', deliveryId).order('created_at', ascending: false).limit(limit);
    return (res as List).map((e) => Delivery.fromMap(e)).toList();
  }
}
