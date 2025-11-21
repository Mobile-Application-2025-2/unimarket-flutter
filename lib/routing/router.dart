import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/home_page_buyer_screen.dart';
import 'package:unimarket/ui/map/widgets/map_screen.dart';
import 'package:unimarket/ui/profile_buyer/view/profile_buyer_view.dart';
import 'package:unimarket/ui/profile_buyer/view_model/profile_buyer_viewmodel.dart';
import 'package:unimarket/ui/shopping_cart/widgets/shopping_cart_screen.dart';

import 'routes.dart';
import 'package:unimarket/ui/login/view/login_view.dart';
import 'package:unimarket/ui/sign_up/view/sign_up_view.dart';
import 'package:unimarket/ui/create_account/view/create_account_view.dart';
import 'package:unimarket/ui/student_code/view/student_code_view.dart';
import 'package:unimarket/ui/student_code/view_model/student_code_viewmodel.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/data/services/camera_service.dart';
import 'package:unimarket/ui/home_buyer/widgets/home_buyer_screen.dart';
import 'package:unimarket/ui/profile_bussines/view/profile_bussines_view.dart';
import 'package:unimarket/ui/profile_bussines/view_model/profile_bussines_viewmodel.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.signUp,
  debugLogDiagnostics: true,
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
      path: Routes.profileBussines,
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => ProfileBussinesViewModel(),
          child: const ProfileBussinesView(),
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
