import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/domain/models/products/product.dart';
import 'package:unimarket/data/models/product_collection.dart';

import 'package:unimarket/utils/result.dart';

import 'product_repository.dart';

class ProductRepositoryFirestore implements ProductRepository {
  ProductRepositoryFirestore({required ProductDao productDao}): _productDao = productDao;

  final ProductDao _productDao;

  @override
  Future<Result<List<Product>>> getProductsList() async {
    try {
      Result<List<ProductCollection>> response = await _productDao.getAllProducts();
      switch (response) {
        case Ok<List<ProductCollection>>():
          final products = response.value;

          return Result.ok(
            products.map((product) => Product.fromJson(product.toMap())).toList()
          );
        case Error<List<ProductCollection>>():
          return Result.error(response.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}