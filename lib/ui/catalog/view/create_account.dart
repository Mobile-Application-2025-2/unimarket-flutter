import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/widgets/back_button.dart';
import '../../core/widgets/title_section.dart';
import '../../core/widgets/social_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/divider_text.dart';
import '../../../controllers/session_controller.dart';
import 'student_code.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPrivacyPolicyAccepted = false;
  bool _isLoading = false;
  String? _accountType;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createAccount() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    if (_accountType == null) {
      _showErrorSnackBar('Please select an account type');
      return;
    }

    if (!_isPrivacyPolicyAccepted) {
      _showErrorSnackBar('Please accept the Privacy Policy');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await SessionController.instance.signup(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        type: _accountType!,
      );

      _showSuccessSnackBar(
        'Account created! Please check your email to verify your account.',
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StudentCodeScreen(userName: _nameController.text.trim()),
          ),
        );
      }
    } on AuthException catch (error) {
      String errorMessage = error.message;
      if (error.statusCode != null) {
        errorMessage = '${error.statusCode} $errorMessage';
      }
      _showErrorSnackBar(errorMessage);
    } catch (error) {
      _showErrorSnackBar('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

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
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(),
                    ),
                    const SizedBox(height: 30),
                    const TitleSection(
                      title: 'Create your account',
                      titleColor: Color(0xFFFFC436),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  SocialButton(
                    text: 'CONTINUE WITH OUTLOOK',
                    backgroundColor: const Color(0xFF0078D4),
                    textColor: Colors.white,
                    icon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xFF0078D4),
                      size: 16,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),

                  SocialButton(
                    text: 'CONTINUE WITH GOOGLE',
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: Colors.grey.shade300,
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const DividerText(text: 'OR CREATE ACCOUNT WITH EMAIL'),

              const SizedBox(height: 32),

              Column(
                children: [
                  // Name field with checkmark
                  CustomTextField(
                    hintText: 'Name',
                    controller: _nameController,
                    suffixIcon: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFFFC436),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFFFC436),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFFFFC436),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _accountType,
                      decoration: const InputDecoration(
                        hintText: 'Select Account Type',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Color(0xFFFFC436),
                          size: 20,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                        DropdownMenuItem(
                          value: 'deliver',
                          child: Text('Deliver'),
                        ),
                        DropdownMenuItem(
                          value: 'business',
                          child: Text('Business'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _accountType = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Checkbox(
                    value: _isPrivacyPolicyAccepted,
                    onChanged: (value) {
                      setState(() {
                        _isPrivacyPolicyAccepted = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFFFC436),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          TextSpan(text: 'I have read the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFFFFC436),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Create Account button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: PrimaryButton(
                  text: 'CREATE ACCOUNT',
                  onPressed: _isLoading ? null : _createAccount,
                  backgroundColor: _isLoading
                      ? Colors.grey
                      : const Color(0xFFFFC436),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
