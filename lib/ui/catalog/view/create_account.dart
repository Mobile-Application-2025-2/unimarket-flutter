import 'package:flutter/material.dart';
import '../../core/widgets/back_button.dart';
import '../../core/widgets/title_section.dart';
import '../../core/widgets/social_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/divider_text.dart';
import 'student_code.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Camilo Martinez');
  final TextEditingController _emailController = TextEditingController(text: 'camimartinez@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••••');
  
  bool _isPasswordVisible = false;
  bool _isPrivacyPolicyAccepted = false;

  @override
  void initState() {
    super.initState();
    _passwordController.text = '••••••••••';
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
              // Top section with back button and title
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Column(
                  children: [
                    // Back button
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(),
                    ),
                    const SizedBox(height: 30),
                    // Title with decorative background
                    const TitleSection(
                      title: 'Create your account',
                      titleColor: Color(0xFFFFC436),
                    ),
                  ],
                ),
              ),
              
              // Social login buttons
              Column(
                children: [
                  // Outlook button
                  SocialButton(
                    text: 'CONTINUE WITH OUTLOOK',
                    backgroundColor: const Color(0xFF0078D4),
                    textColor: Colors.white,
                    icon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xFF0078D4),
                      size: 16,
                    ),
                    onPressed: () {
                      // Handle Outlook login
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Google button
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
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Divider text
              const DividerText(text: 'OR LOG IN WITH EMAIL'),
              
              const SizedBox(height: 32),
              
              // Input fields
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
                  
                  // Email field with checkmark
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
                  
                  // Password field with eye icon
                  CustomTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Privacy Policy checkbox
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
              
              // Sign In button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: PrimaryButton(
                  text: 'SIGN IN',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentCodeScreen(),
                      ),
                    );
                  },
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
