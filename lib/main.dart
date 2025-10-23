import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
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
import 'package:unimarket/controllers/session_controller.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SessionController.instance),
        Provider(create: (_) => CameraService()),
        Provider(create: (_) => PopularityService(Supabase.instance.client)),
        Provider(create: (_) => PlacesService(apiKey: 'AIzaSyDmWwy5o6U0ELq2oDwYBkjmFQgdOabADxE')),
        ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<SessionController>()),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CreateAccountViewModel(ctx.read<SessionController>()),
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
        home: const SignUpView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
