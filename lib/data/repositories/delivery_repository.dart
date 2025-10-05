import '../../models/delivery.dart';

abstract class DeliveryRepository {
  Future<List<Delivery>> getAll({int limit = 50});
  Future<Delivery?> getById(String id);
  Future<String> create(Delivery delivery);
  Future<void> update(Delivery delivery);
  Future<void> delete(String id);

  // extras típicos
  Future<List<Delivery>> getByBuyer(String buyerId, {int limit = 50});
  Future<List<Delivery>> getByDeliveryPerson(String deliveryId, {int limit = 50});
}
