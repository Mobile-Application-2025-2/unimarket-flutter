import 'package:flutter/material.dart';
import 'package:unimarket/utils/not_implemented_snackbar.dart';
 

class SocialMediaButtonGroup extends StatelessWidget {
  const SocialMediaButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => notImplementedFunctionalitySnackbar(context),
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0078D4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.mail_outline, color: Colors.white, size: 16),
                SizedBox(width: 12),
                Text('CONTINUE WITH OUTLOOK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => notImplementedFunctionalitySnackbar(context),
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('G', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 12),
                Text('CONTINUE WITH GOOGLE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
