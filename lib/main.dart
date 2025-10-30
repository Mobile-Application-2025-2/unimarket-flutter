import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Views
import 'package:unimarket/ui/sign_up/view/sign_up_view.dart';

// ViewModels
import 'package:unimarket/ui/login/view_model/login_viewmodel.dart';
import 'package:unimarket/ui/sign_up/view_model/sign_up_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/create_account_viewmodel.dart';
import 'package:unimarket/ui/create_account/view_model/session_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/student_code_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/home_deliver_viewmodel.dart';
// TODO: Reconnect ExploreBuyerViewModel and HomeBuyerViewModel with Firebase later
// import 'package:unimarket/viewmodel/catalog/explore_buyer_viewmodel.dart';
// import 'package:unimarket/viewmodel/catalog/home_buyer_viewmodel.dart';

// Services
import 'package:unimarket/data/models/services/firebase_auth_service_adapter.dart';
import 'package:unimarket/data/models/services/camera_service.dart';
import 'package:unimarket/data/models/services/places_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (once)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handle Flutter framework errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Handle errors outside of Flutter framework
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Firebase Authentication Service
        Provider(
          create: (_) => FirebaseAuthService(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),

        // Other Services
        Provider(create: (_) => CameraService()),

        Provider(
          create: (_) => PlacesService(
            apiKey: 'AIzaSyDmWwy5o6U0ELq2oDwYBkjmFQgdOabADxE',
          ),
        ),

        // Session ViewModel (Firebase-based auth state)
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
        ChangeNotifierProvider(
          create: (ctx) => StudentCodeViewModel(ctx.read<CameraService>()),
        ),

        ChangeNotifierProvider(
          create: (ctx) => HomeDeliverViewModel(ctx.read<PlacesService>()),
        ),

        // TODO: Reconnect these ViewModels with Firebase later
        // ChangeNotifierProvider(
        //   create: (ctx) => ExploreBuyerViewModel(),
        // ),
        // ChangeNotifierProvider(
        //   create: (ctx) => HomeBuyerViewModel(),
        // ),
      ],
      child: MaterialApp(
        title: 'UniMarket',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            headlineMedium: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            headlineSmall: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            titleLarge: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            titleMedium: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
            titleSmall: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFFC436), // Color principal
            onPrimary: Colors.white,
            secondary: Color(0xFFF7D547),
            tertiary: Color(0xFFFFD27C),
            error: Colors.red,
            onError: Colors.white,
            outline: Color(0xFFB57C00),
            shadow: Color(0xFFD09306),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFECAB0F),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC436),
              foregroundColor: Colors.white,
              elevation: 2,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFFFC436),
            foregroundColor: Colors.white,
          ),
        ),
        home: const SignUpView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
