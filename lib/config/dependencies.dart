import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:unimarket/data/daos/business_dao.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/repositories/businesses/business_repository.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// ViewModels
import 'package:unimarket/ui/login/view_model/login_viewmodel.dart';
import 'package:unimarket/ui/sign_up/view_model/sign_up_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/create_account_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/session_viewmodel.dart';

// Services
import 'package:unimarket/data/models/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/models/services/camera_service.dart';
import 'package:unimarket/data/repositories/products/product_repository_firestore.dart';
import 'package:unimarket/data/repositories/businesses/business_repository_firestore.dart';

List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (_) => BusinessRepositoryFirestore(businessDao: BusinessDao()) as BusinessRepository
    ),
    Provider(
      create: (_) => ProductRepositoryFirestore(productDao: ProductDao()) as ProductRepository,
    ),
            Provider(
          create: (_) => FirebaseAuthService(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
                ChangeNotifierProvider(
          create: (ctx) => SessionViewModel(ctx.read<FirebaseAuthService>()),
        ),

        // Auth ViewModels (Login & Create Account use Firebase)
        ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<FirebaseAuthService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CreateAccountViewModel(ctx.read<FirebaseAuthService>()),
        ),
                // Other ViewModels
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
        ),
        // Other Services
        Provider(create: (_) => CameraService()),
    ..._sharedProviders,
  ];
}
