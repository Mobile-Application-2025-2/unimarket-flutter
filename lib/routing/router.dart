import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/home_page_buyer_screen.dart';
import 'package:unimarket/ui/map/widgets/map_screen.dart';
import 'package:unimarket/ui/profile_buyer/view/profile_buyer_view.dart';
import 'package:unimarket/ui/profile_buyer/view_model/profile_buyer_viewmodel.dart';
import 'package:unimarket/ui/profile_business/view/profile_business_view.dart';
import 'package:unimarket/ui/profile_business/view_model/profile_business_viewmodel.dart';
import 'package:unimarket/ui/shopping_cart/widgets/shopping_cart_screen.dart';
import 'routes.dart';
import 'package:unimarket/ui/login/view/login_view.dart';
import 'package:unimarket/ui/sign_up/view/sign_up_view.dart';
import 'package:unimarket/ui/create_account/view/create_account_view.dart';
import 'package:unimarket/ui/student_code/view/student_code_view.dart';
import 'package:unimarket/ui/student_code/view_model/student_code_viewmodel.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/data/daos/business_data_dao.dart';
import 'package:unimarket/data/services/camera_service.dart';
import 'package:unimarket/ui/home_buyer/widgets/home_buyer_screen.dart';
import 'package:unimarket/ui/business_data/view/business_data_view.dart';
import 'package:unimarket/ui/business_data/view_model/business_data_viewmodel.dart';
import 'package:unimarket/utils/singleton.dart';
import 'package:unimarket/data/services/cache_service.dart';
import 'package:unimarket/utils/result.dart';

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  
  // If Firebase has a current user, route based on account type and DAOs
  if (firebaseUser != null) {
    // Check if email is verified
    if (!firebaseUser.emailVerified) {
      // User not verified, allow access to login/signup but not authenticated routes
      if (state.matchedLocation == Routes.login || 
          state.matchedLocation == Routes.signUp || 
          state.matchedLocation == Routes.createAccount) {
        return null; // Allow access
      }
      return Routes.login; // Redirect unverified users to login
    }
    
    // User is authenticated and verified, check account type and route accordingly
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      final data = snap.data() ?? {};
      final accountType = (data['accountType']?.toString()) ?? 'buyer';
      
      final studentCodeDao = Singleton<StudentCodeDao>().instance;
      final businessDataDao = Singleton<BusinessDataDao>().instance;
      
      // If already on an authenticated route, allow it
      final authRoutes = [
        Routes.homeBuyer,
        Routes.homePageBuyer,
        Routes.studentCode,
        Routes.businessData,
        Routes.profileBuyer,
        Routes.profileBusiness,
        Routes.shoppingCart,
        Routes.map,
      ];
      
      if (authRoutes.contains(state.matchedLocation)) {
        return null; // Allow access to authenticated routes
      }
      
      // Route based on account type
      if (accountType == 'business') {
        final hasBusinessData = await businessDataDao.hasSubmission(firebaseUser.uid);
        if (hasBusinessData) {
          return Routes.homePageBuyer;
        } else {
          return Routes.businessData;
        }
      } else {
        final submissionResult = await studentCodeDao.hasSubmission(firebaseUser.uid);
        if (submissionResult is Ok<bool> && submissionResult.value == true) {
          return Routes.homePageBuyer;
        } else {
          return Routes.studentCode;
        }
      }
    } catch (e) {
      return null;
    }
  }
  
  // No Firebase user, check cache
  final cache = Singleton<CacheService>().instance;
  if (cache.rememberMe && cache.cachedUid != null) {
    if (state.matchedLocation == Routes.login || 
        state.matchedLocation == Routes.signUp || 
        state.matchedLocation == Routes.createAccount) {
      return null; // Allow access to auth screens
    }
    return Routes.login;
  }
  
  // No user and no remembered session, route to sign up
  if (state.matchedLocation == Routes.signUp || 
      state.matchedLocation == Routes.login || 
      state.matchedLocation == Routes.createAccount) {
    return null; // Allow access to auth screens
  }
  return Routes.signUp;
}

GoRouter router() => GoRouter(
  initialLocation: Routes.signUp,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignUpView(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => const LoginView()),
    GoRoute(
      path: Routes.createAccount,
      builder: (context, state) => const CreateAccountView(),
    ),
    GoRoute(
      path: Routes.studentCode,
      builder: (context, state) {
        final name = (state.extra is String) ? state.extra as String : '';
        final camera = context.read<CameraService>();
        final dao = context.read<StudentCodeDao>();
        return ChangeNotifierProvider(
          create: (_) =>
              StudentCodeViewModel(camera, dao, initialUserName: name),
          builder: (ctx, _) => StudentCodeView(userName: name),
        );
      },
    ),
    GoRoute(
      path: Routes.businessData,
      builder: (context, state) {
        final name = (state.extra is String) ? state.extra as String : '';
        final camera = context.read<CameraService>();
        final dao = context.read<BusinessDataDao>();
        return ChangeNotifierProvider(
          create: (_) =>
              BusinessDataViewModel(camera, dao, initialUserName: name),
          builder: (ctx, _) => BusinessDataView(userName: name),
        );
      },
    ),
    GoRoute(
      path: Routes.homeBuyer,
      builder: (context, state) {
        final repo = context.read<ProductRepository>();
        return HomeBuyerScreen(
          viewModel: HomeBuyerViewModel(productRepository: repo),
          shoppingCartViewModel: context.read(),
        );
      },
    ),
    GoRoute(
      path: Routes.homePageBuyer,
      builder: (context, state) {
        return HomePageBuyerScreen(
          viewModel: HomePageBuyerViewModel(businessRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.profileBuyer,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => ProfileBuyerViewModel(),
          child: const ProfileBuyerView(),
        );
      },
    ),
    GoRoute(
      path: Routes.profileBusiness,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => ProfileBusinessViewModel(),
          child: const ProfileBusinessView(),
        );
      },
    ),
    GoRoute(
      path: Routes.shoppingCart,
      builder: (context, state) =>
          ShoppingCartScreen(viewModel: context.read()),
    ),
    GoRoute(
      path: Routes.map,
      builder: (_, __) => const MapScreen(),
    )
  ],
);
