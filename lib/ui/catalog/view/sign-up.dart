import 'package:flutter/material.dart';
import 'login.dart';
import 'create-account.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Top section with MAIN text
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                child: Align(
                  alignment: Alignment.centerLeft,                  
                ),
              ),
              
              // Logo section with image and text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo image
                    Image.asset(
                      'images/sign.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // UniMarket text
                    const Text(
                      'UNIMARKET',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC436), // Orange-yellow color
                        fontFamily: 'Poppins',
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Sign Up button
              PrimaryButton(
                text: 'SIGN UP',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Login link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: 'ALREADY HAVE AN ACCOUNT? ',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
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
        ),
      ),
    );
  }
}

// Import the PrimaryButton component
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;
  
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(0xFFFFC436),
    this.textColor = Colors.white,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
