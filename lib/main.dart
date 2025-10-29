import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/ui/home_buyer/widgets/home_buyer_screen.dart';
import 'package:unimarket/view/catalog/sign_up_view.dart';
import 'package:unimarket/viewmodel/catalog/login_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/sign_up_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/create_account_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/student_code_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/explore_buyer_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/home_deliver_viewmodel.dart';
import 'package:unimarket/viewmodel/catalog/home_buyer_viewmodel.dart';
import 'package:unimarket/model/shared/services/camera_service.dart';
import 'package:unimarket/model/shared/services/popularity_service.dart';
import 'package:unimarket/model/shared/services/places_service.dart';
import 'package:unimarket/model/shared/services/supabase_service.dart';
import 'package:unimarket/model/shared/services/auth_service.dart';
import 'package:unimarket/viewmodel/app/session_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // handle the errors of Flutter framework
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // handle errors outside of Flutter framework
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
        // Services
        Provider(create: (_) => SupabaseService(
          url: 'https://fiieipssuysdlntvfhkg.supabase.co',
          anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpaWVpcHNzdXlzZGxudHZmaGtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1OTU1NDEsImV4cCI6MjA3NTE3MTU0MX0.eIZvRlF4tUCMa76KlWkZdBAOGx6L4wPO8xjtCD-6U4A',
        )),
        Provider(create: (ctx) => AuthService(ctx.read<SupabaseService>())),
        Provider(create: (_) => CameraService()),
        Provider(create: (ctx) => PopularityService(ctx.read<SupabaseService>().client)),
        Provider(create: (_) => PlacesService(apiKey: 'AIzaSyDmWwy5o6U0ELq2oDwYBkjmFQgdOabADxE')),

        // ViewModels
        ChangeNotifierProvider(
          create: (ctx) => SessionViewModel(ctx.read<AuthService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<SessionViewModel>()),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CreateAccountViewModel(ctx.read<SessionViewModel>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => StudentCodeViewModel(ctx.read<CameraService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ExploreBuyerViewModel(ctx.read<PopularityService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeDeliverViewModel(ctx.read<PlacesService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeBuyerViewModel(ctx.read<PopularityService>()),
        ),
      ],
      child: MaterialApp(
        title: 'UniMarket',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'Poppins'),
            headlineMedium: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
            headlineSmall: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
            titleLarge: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
            titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
            titleSmall: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
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
          )
        ),
        home: HomeBuyerScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

