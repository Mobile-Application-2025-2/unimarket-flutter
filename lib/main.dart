import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:unimarket/routing/router.dart';
import 'package:unimarket/config/dependencies.dart';
import 'package:unimarket/core/utils/singleton.dart';
import 'package:unimarket/data/models/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/models/services/camera_service.dart';
import 'package:unimarket/data/daos/create_account_dao.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/data/daos/product_dao.dart';
import 'package:unimarket/data/daos/business_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (once)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // handle errors outside of Flutter framework
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  // Register all singleton services
  Singleton.register<FirebaseAuthService>(
    FirebaseAuthService(FirebaseAuth.instance, FirebaseFirestore.instance),
  );
  Singleton.register<CameraService>(CameraService());
  Singleton.register<StudentCodeDao>(StudentCodeDao());
  Singleton.register<CreateAccountDao>(CreateAccountDao());
  Singleton.register<ProductDao>(ProductDao());
  Singleton.register<BusinessDao>(BusinessDao());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        routerConfig: router(),
        title: 'UniMarket',
        debugShowCheckedModeBanner: false,
      )
    );
  }
}
