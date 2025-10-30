import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:unimarket/routing/routes.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
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
      }
    ),
    GoRoute(
      path: Routes.homeBuyer,
      builder: (context, state) {
        return HomePageBuyerScreen(
          viewModel: HomePageBuyerViewModel(businessRepository: context.read()),
        );
      },
    ),
  ],
);
