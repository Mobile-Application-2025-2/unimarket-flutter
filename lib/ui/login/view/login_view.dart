import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/login_viewmodel.dart';
import 'package:unimarket/ui/core/ui/email_field.dart';
import 'package:unimarket/ui/core/ui/password_field.dart';
import '../widgets/login_button.dart';
import '../widgets/error_banner.dart';
import '../../../../ui/create_account/view/create_account_view.dart';
import '../../../../ui/home_buyer/widgets/home_buyer_screen.dart';
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
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
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
                      final success = await viewModel.signIn();
                      if (!context.mounted) return;

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeBuyerScreen(),
                          ),
                        );
                      } else if (viewModel.state.error != null) {
                        // Show error in SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(viewModel.state.error!),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateAccountView(),
                                ),
                              );
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
