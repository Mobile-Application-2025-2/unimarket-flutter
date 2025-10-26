import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/catalog/create_account_viewmodel.dart';
import '../shared/widgets/back_button.dart';
import '../shared/widgets/title_section.dart';
import '../shared/widgets/social_button.dart';
import '../shared/widgets/custom_textfield.dart';
import '../shared/widgets/primary_button.dart';
import '../shared/widgets/divider_text.dart';
import '../../../view/catalog/student_code_view.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
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

              Consumer<CreateAccountViewModel>(
                builder: (context, vm, _) {
                  return Column(
                    children: [
                      // Name field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: 'Name',
                            onChanged: vm.setName,
                            suffixIcon: vm.name.isNotEmpty && vm.nameError == null
                                ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
                                : null,
                          ),
                          if (vm.nameError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 6),
                              child: Text(
                                vm.nameError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Email field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: vm.setEmail,
                            suffixIcon: vm.email.isNotEmpty && vm.emailError == null
                                ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
                                : null,
                          ),
                          if (vm.emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 6),
                              child: Text(
                                vm.emailError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Password field
                      CustomTextField(
                        hintText: 'Password',
                        obscureText: true,
                        onChanged: vm.setPassword,
                      ),
                      const SizedBox(height: 16),
                      
                      // Confirm Password field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: 'Confirm Password',
                            obscureText: true,
                            onChanged: vm.setConfirmPassword,
                            suffixIcon: vm.confirmPassword.isNotEmpty && vm.passwordError == null && vm.password.isNotEmpty
                                ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
                                : null,
                          ),
                          if (vm.passwordError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 6),
                              child: Text(
                                vm.passwordError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Account Type dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: vm.accountType,
                          decoration: const InputDecoration(
                            hintText: 'Select Account Type',
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            prefixIcon: Icon(Icons.person_outline, color: Color(0xFFFFC436), size: 20),
                          ),
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
                          items: const [
                            DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                            DropdownMenuItem(value: 'deliver', child: Text('Deliver')),
                            DropdownMenuItem(value: 'business', child: Text('Business')),
                          ],
                          onChanged: vm.setAccountType,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              Consumer<CreateAccountViewModel>(
                builder: (context, vm, _) {
                  return Row(
                    children: [
                      Checkbox(
                        value: vm.acceptedPrivacy,
                        onChanged: (v) => vm.setAcceptedPrivacy(v ?? false),
                        activeColor: const Color(0xFFFFC436),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Poppins'),
                            children: [
                              TextSpan(text: 'I have read the '),
                              TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFFFFC436), fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              Consumer<CreateAccountViewModel>(
                builder: (context, vm, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: PrimaryButton(
                      text: 'CREATE ACCOUNT',
                      onPressed: vm.isLoading || !vm.isValid
                          ? null
                          : () async {
                              final name = await vm.createAccount();
                              if (name != null && context.mounted) {
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
                                  MaterialPageRoute(builder: (context) => StudentCodeView(userName: name.trim())),
                                );
                              } else if (vm.errorMessage != null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(vm.errorMessage!),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                      backgroundColor: vm.isLoading ? Colors.grey : const Color(0xFFFFC436),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


