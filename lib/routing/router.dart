import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';

import 'routes.dart';
import 'package:unimarket/ui/login/view/login_view.dart';
import 'package:unimarket/ui/sign_up/view/sign_up_view.dart';
import 'package:unimarket/ui/create_account/view/create_account_view.dart';
import 'package:unimarket/ui/student_code/view/student_code_view.dart';
import 'package:unimarket/ui/home_buyer/widgets/home_buyer_screen.dart';
import 'package:unimarket/ui/home_page_buyer/view_model/home_page_buyer_vm.dart';
import 'package:unimarket/ui/home_page_buyer/widgets/home_page_buyer_screen.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.homeBuyer,
  debugLogDiagnostics: true,
  // redirect: _redirect,
  // refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.homePageBuyer,
      builder: (context, state) {
        return HomeBuyerScreen(
          viewModel: HomeBuyerViewModel(productRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.homeBuyer,
      builder: (context, state) {
        return HomePageBuyerScreen(
          viewModel: HomePageBuyerViewModel(businessRepository: context.read()),
        );
      },
    ),
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
        return StudentCodeView(userName: name);
      },
    ),
    GoRoute(
      path: Routes.homeBuyer,
      builder: (context, state) {
        final repo = context.read<ProductRepository>();
        return HomeBuyerScreen(
          viewModel: HomeBuyerViewModel(productRepository: repo),
        );
      },
    ),
  ],
);
