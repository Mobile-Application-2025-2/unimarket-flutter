import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'package:unimarket/ui/login/view/login_view.dart';
import 'package:unimarket/ui/sign_up/view/sign_up_view.dart';
import 'package:unimarket/ui/create_account/view/create_account_view.dart';
import 'package:unimarket/ui/student_code/view/student_code_view.dart';
import 'package:unimarket/ui/home_buyer/widgets/home_buyer_screen.dart';
import 'package:unimarket/ui/home_buyer/view_model/home_buyer_vm.dart';
import 'package:unimarket/data/repositories/products/product_repository.dart';
import 'package:unimarket/ui/profile_buyer/view/profile_buyer_view.dart';
import 'package:unimarket/ui/profile_buyer/view_model/profile_buyer_viewmodel.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.signUp,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.signUp,
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginView(),
        ),
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
        GoRoute(
          path: Routes.profileBuyer,
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (_) => ProfileBuyerViewModel(),
              child: const ProfileBuyerView(),
            );
          },
        ),
      ],
    );
