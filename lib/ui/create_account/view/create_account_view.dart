import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/create_account_viewmodel.dart';
import '../widgets/back_button.dart';
import '../widgets/title_section.dart';
import '../../core/ui/primary_button.dart';
import '../widgets/divider_text.dart';
import '../widgets/name_field.dart';
import 'package:unimarket/ui/core/ui/email_field.dart';
import 'package:unimarket/ui/core/ui/password_field.dart';
import 'package:unimarket/ui/create_account/widgets/confirm_password_field.dart';
import '../widgets/account_type_dropdown.dart';
import '../widgets/privacy_checkbox.dart';
import '../../login/widgets/social_media_button.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});
//holaaaaa
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreateAccountViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final state = viewModel.state;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Column(
                      children: const [
                        Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
                        SizedBox(height: 30),
                        TitleSection(title: 'Create your account', titleColor: Color(0xFFFFC436)),
                      ],
                    ),
                  ),

                  const SocialMediaButtonGroup(),

                  const SizedBox(height: 32),
                  const DividerText(text: 'OR CREATE ACCOUNT WITH EMAIL'),
                  const SizedBox(height: 32),

                  // Error message display
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  // Name field
                  NameField(
                    value: state.name,
                    errorText: state.nameError,
                    onChanged: viewModel.setName,
                    enabled: !state.loading,
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  EmailField(
                    value: state.email,
                    errorText: state.emailError,
                    onChanged: viewModel.setEmail,
                    enabled: !state.loading,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  PasswordField(
                    value: state.password,
                    errorText: state.passwordError,
                    onChanged: viewModel.setPassword,
                    enabled: !state.loading,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  ConfirmPasswordField(
                    value: state.confirmPassword,
                    valid: state.passwordsMatch,
                    errorText: state.passwordError,
                    onChanged: viewModel.setConfirmPassword,
                    enabled: !state.loading,
                  ),
                  const SizedBox(height: 16),

                  // Account Type dropdown
                  AccountTypeDropdown(
                    value: state.accountType,
                    onChanged: viewModel.setAccountType,
                    enabled: !state.loading,
                  ),

                  const SizedBox(height: 24),

                  // Privacy checkbox
                  PrivacyCheckbox(
                    value: state.acceptedPrivacy,
                    onChanged: viewModel.setAcceptedPrivacy,
                    enabled: !state.loading,
                  ),

                  const SizedBox(height: 40),

                  // Create account button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: PrimaryButton(
                      text: state.loading ? 'CREATING...' : 'CREATE ACCOUNT',
                      onPressed: state.loading || !state.isValid
                          ? null
                          : () async {
                              await viewModel.createAccount();
                              if (!context.mounted) return;

                              if (viewModel.state.errorMessage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Account created! Please check your email to verify your account.'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                                context.go(Routes.login);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.state.errorMessage!),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                      backgroundColor: state.loading ? Colors.grey : const Color(0xFFFFC436),
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
