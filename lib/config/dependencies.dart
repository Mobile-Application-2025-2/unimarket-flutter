import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';

import 'package:unimarket/data/repositories/products/product_repository_firestore.dart';

List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => ProductRepositoryFirestore(productDao: ProductDao()) as ProductRepository,
    ),
    ..._sharedProviders,
  ];
}
