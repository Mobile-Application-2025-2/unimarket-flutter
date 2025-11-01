import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/repositories/businesses/business_repository.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';

// Singleton utility
import 'package:unimarket/core/utils/singleton.dart';

// ViewModels
import 'package:unimarket/ui/login/view_model/login_viewmodel.dart';
import 'package:unimarket/ui/sign_up/view_model/sign_up_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/create_account_viewmodel.dart';
import 'package:unimarket/data/daos/create_account_dao.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';

// Services
import 'package:unimarket/data/models/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/models/services/camera_service.dart';
import 'package:unimarket/data/repositories/products/product_repository_firestore.dart';
import 'package:unimarket/data/repositories/businesses/business_repository_firestore.dart';

List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providers {
  return [
    // Repositories use Singleton DAOs
    Provider(
      create: (_) => BusinessRepositoryFirestore(businessDao: Singleton<BusinessDao>().instance) as BusinessRepository
    ),
    Provider(
      create: (_) => ProductRepositoryFirestore(productDao: Singleton<ProductDao>().instance) as ProductRepository,
    ),
    // Services from Singleton
    Provider(
      create: (_) => Singleton<FirebaseAuthService>().instance,
    ),

    // DAOs from Singleton
    Provider(create: (_) => Singleton<CreateAccountDao>().instance),
    Provider(create: (_) => Singleton<StudentCodeDao>().instance),
    // Auth ViewModels use Singleton instances
    ChangeNotifierProvider(
      create: (ctx) => LoginViewModel(
        ctx.read<FirebaseAuthService>(),
        ctx.read<StudentCodeDao>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (ctx) => CreateAccountViewModel(dao: ctx.read<CreateAccountDao>()),
    ),
    // Other ViewModels
    ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
    ),
    // Services from Singleton
    Provider(create: (_) => Singleton<CameraService>().instance),
    ..._sharedProviders,
  ];
}
