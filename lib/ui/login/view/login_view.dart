import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/login_viewmodel.dart';
import 'package:unimarket/ui/core/ui/email_field.dart';
import 'package:unimarket/ui/core/ui/password_field.dart';
import '../widgets/login_button.dart';
import '../widgets/error_banner.dart';
import 'package:unimarket/ui/create_account/widgets/back_button.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';
import 'package:unimarket/utils/result.dart';

// notImplementedFunctionalitySnackbar used inside SocialMediaButtonGroup, no direct usage here
import '../widgets/social_media_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

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
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomBackButton(),
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            Positioned(
                              top: -20,
                              left: -20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFC436).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: -30,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7D547).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const Center(
                              child: Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFC436),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SocialMediaButtonGroup(),

                  const SizedBox(height: 32),

                  const Text(
                    'OR LOG IN WITH EMAIL',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Error message display
                  if (state.error != null)
                    ErrorBanner(
                      message: state.error!,
                      onRetry: viewModel.clearError,
                    ),

                  // Email field
                  EmailField(
                    value: state.email,
                    onChanged: viewModel.setEmail,
                    enabled: !state.loading,
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  PasswordField(
                    value: state.password,
                    visible: state.showPassword,
                    onChanged: viewModel.setPassword,
                    onToggleVisibility: viewModel.togglePasswordVisibility,
                    enabled: !state.loading,
                  ),

                  const SizedBox(height: 32),

                  // Login button
                  LoginButton(
                    enabled: state.canSubmit,
                    loading: state.loading,
                    onPressed: () async {
                      final result = await viewModel.login(state.email, state.password);
                      if (!context.mounted) return;
                      if (result is Ok<String>) {
                        final type = result.value;
                        if (type == 'buyer') {
                          context.go(Routes.studentCode, extra: state.email.trim());
                        } else if (type == 'deliver') {
                          context.go(Routes.homeBuyer);
                        } else {
                          context.go(Routes.homeBuyer);
                        }
                      } else {
                        final snack = SnackBar(
                          content: Text(viewModel.state.error ?? 'Login failed'),
                          action: SnackBarAction(
                            label: 'Resend',
                            onPressed: () async {
                              final resend = await viewModel.resendVerification(state.email, state.password);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(resend is Ok<void>
                                      ? 'Verification email sent.'
                                      : 'Could not resend. Try again.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Forgot password link
                  TextButton(
                    onPressed: state.loading
                        ? null
                        : () async {
                            await viewModel.resetPassword();
                          },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: GestureDetector(
                      onTap: state.loading
                          ? null
                          : () {
                              context.go(Routes.createAccount);
                            },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(text: 'DON\'T HAVE AN ACCOUNT? '),
                            TextSpan(
                              text: 'CREATE ACCOUNT',
                              style: TextStyle(
                                color: Color(0xFFFFC436),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
