import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/sign_up_viewmodel.dart';
import '../widgets/primary_button.dart';
import '../../login/view/login_view.dart';
import '../../create_account/view/create_account_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SignUpViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final state = viewModel.state;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Logo and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sign.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'UNIMARKET',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFC436),
                          fontFamily: 'Poppins',
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  // Error message display
                  if (state.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        state.error!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Sign Up button
                  PrimaryButton(
                    text: state.loading ? 'LOADING...' : 'SIGN UP',
                    onPressed: state.loading
                        ? null
                        : () async {
                            await viewModel.startLoading();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateAccountView(),
                                ),
                              );
                            }
                          },
                  ),

                  const SizedBox(height: 24),

                  // Login link
                  GestureDetector(
                    onTap: state.loading
                        ? null
                        : () async {
                            await viewModel.startLoading();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              );
                            }
                          },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                        children: [
                          TextSpan(
                            text: 'ALREADY HAVE AN ACCOUNT? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'LOG IN',
                            style: TextStyle(
                              color: Color(0xFFFFC436),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
