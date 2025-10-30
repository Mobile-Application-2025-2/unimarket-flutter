import 'package:flutter/material.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import 'package:unimarket/view/shared/widgets/social_button.dart';

class SocialMediaButtonGroup extends StatelessWidget {
  const SocialMediaButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(
          text: 'CONTINUE WITH OUTLOOK',
          backgroundColor: const Color(0xFF0078D4),
          textColor: Colors.white,
          icon: const Icon(Icons.mail_outline, color: Color(0xFF0078D4), size: 16),
          onPressed: () {
            notImplementedFunctionalitySnackbar(context);
          },
        ),
        const SizedBox(height: 16),
        SocialButton(
          text: 'CONTINUE WITH GOOGLE',
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          icon: const Text(
            'G',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            notImplementedFunctionalitySnackbar(context);
          },
        ),
      ],
    );
  }
}
