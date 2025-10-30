import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/models/address_property.dart';
import 'package:unimarket/data/models/business_collection.dart';
import 'package:unimarket/domain/models/business/address.dart';
import 'package:unimarket/domain/models/business/business.dart';

import 'package:unimarket/utils/result.dart';

import 'business_repository.dart';

class BusinessRepositoryFirestore implements BusinessRepository {
  BusinessRepositoryFirestore({required BusinessDao businessDao}): _businessDao = businessDao ;

  final BusinessDao _businessDao;

  @override
  Future<Result<List<Business>>> getBusinessList() async {
    try {
      Result<List<BusinessCollection>> response = await _businessDao.getAllBusiness();

      switch (response) {
        case Ok<List<BusinessCollection>>():
          final businesses = response.value;
          return Result.ok(
              businesses.map((business) {
                AddressProperty addressProperty = business.address;
                Address address = Address.fromJson(addressProperty.toMap());

                return Business.fromJson({
                  ...business.toMap(),
                  'address': address.toJson()
                });
              }).toList()
          );
        case Error<List<BusinessCollection>>():
          return Result.error(response.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
