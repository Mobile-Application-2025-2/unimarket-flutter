import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/daos/order_dao.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/repositories/businesses/business_repository.dart';
import 'package:unimarket/data/repositories/orders/order_repository.dart';
import 'package:unimarket/data/repositories/orders/order_repository_firestore.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/ui/shopping_cart/view_model/shopping_cart_vm.dart';

// Singleton utility
import 'package:unimarket/utils/singleton.dart';

// ViewModels
import 'package:unimarket/ui/login/view_model/login_viewmodel.dart';
import 'package:unimarket/ui/sign_up/view_model/sign_up_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/create_account_viewmodel.dart';
import 'package:unimarket/data/daos/create_account_dao.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/data/daos/business_data_dao.dart';

// Services
import 'package:unimarket/data/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/services/camera_service.dart';
import 'package:unimarket/data/repositories/products/product_repository_firestore.dart';
import 'package:unimarket/data/repositories/businesses/business_repository_firestore.dart';

List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => BusinessRepositoryFirestore(businessDao: Singleton<BusinessDao>().instance) as BusinessRepository
    ),
    Provider(
      create: (_) => Singleton<FirebaseAuthService>().instance,
    ),
    Provider(
      create: (_) => ProductRepositoryFirestore(productDao: Singleton<ProductDao>().instance) as ProductRepository,
    ),
    Provider(
      create: (context) => OrderRepositoryFirestore(orderDao: OrderDao(), firebaseAuthServiceAdapter: context.read<FirebaseAuthService>()) as OrderRepository
    ),
    ChangeNotifierProvider(
      create: (context) => ShoppingCartViewModel(orderRepository: context.read())
    ),

    Provider(create: (_) => Singleton<CreateAccountDao>().instance),
    Provider(create: (_) => Singleton<StudentCodeDao>().instance),
    Provider(create: (_) => Singleton<BusinessDataDao>().instance),
    ChangeNotifierProvider(
      create: (ctx) => LoginViewModel(
        ctx.read<FirebaseAuthService>(),
        ctx.read<StudentCodeDao>(),
        ctx.read<BusinessDataDao>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (ctx) => CreateAccountViewModel(dao: ctx.read<CreateAccountDao>()),
    ),

    ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
    ),

    Provider(create: (_) => Singleton<CameraService>().instance),
    ..._sharedProviders,
  ];
}
