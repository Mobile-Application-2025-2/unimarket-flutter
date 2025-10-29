import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/create_account_viewmodel.dart';
import '../../../view/shared/widgets/back_button.dart';
import '../../../view/shared/widgets/title_section.dart';
import '../../../view/shared/widgets/social_button.dart';
import '../../../view/shared/widgets/primary_button.dart';
import '../../../view/shared/widgets/divider_text.dart';
import '../widgets/name_field.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/account_type_dropdown.dart';
import '../widgets/privacy_checkbox.dart';
import '../../../../view/catalog/student_code_view.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    final state = vm.state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Column(
                  children: const [
                    Align(alignment: Alignment.centerLeft, child: CustomBackButton()),
                    SizedBox(height: 30),
                    TitleSection(title: 'Create your account', titleColor: Color(0xFFFFC436)),
                  ],
                ),
              ),

              Column(
                children: [
                  SocialButton(
                    text: 'CONTINUE WITH OUTLOOK',
                    backgroundColor: const Color(0xFF0078D4),
                    textColor: Colors.white,
                    icon: const Icon(Icons.mail_outline, color: Color(0xFF0078D4), size: 16),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    text: 'CONTINUE WITH GOOGLE',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.grey.shade300,
                    icon: const Text('G', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {},
                  ),
                ],
              ),

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
                onChanged: vm.setName,
                enabled: !state.loading,
              ),
              const SizedBox(height: 16),

              // Email field
              EmailField(
                value: state.email,
                errorText: state.emailError,
                onChanged: vm.setEmail,
                enabled: !state.loading,
              ),
              const SizedBox(height: 16),

              // Password field
              PasswordField(
                value: state.password,
                errorText: state.passwordError,
                onChanged: vm.setPassword,
                enabled: !state.loading,
              ),
              const SizedBox(height: 16),

              // Confirm Password field
              ConfirmPasswordField(
                value: state.confirmPassword,
                valid: state.passwordsMatch,
                errorText: state.passwordError,
                onChanged: vm.setConfirmPassword,
                enabled: !state.loading,
              ),
              const SizedBox(height: 16),

              // Account Type dropdown
              AccountTypeDropdown(
                value: state.accountType,
                onChanged: vm.setAccountType,
                enabled: !state.loading,
              ),

              const SizedBox(height: 24),

              // Privacy checkbox
              PrivacyCheckbox(
                value: state.acceptedPrivacy,
                onChanged: vm.setAcceptedPrivacy,
                enabled: !state.loading,
              ),

              const SizedBox(height: 40),

              // Create account button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: PrimaryButton(
                  text: state.loading ? 'CREATING...' : 'CREATE ACCOUNT',
                  onPressed: state.loading || !state.isValid
                      ? null
                      : () async {
                          final name = await vm.createAccount();
                          if (!context.mounted) return;

                          if (name != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account created! Please check your email to verify your account.'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 4),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => StudentCodeView(userName: name.trim())),
                            );
                          } else if (state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage!),
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
        ),
      ),
    );
  }
}
