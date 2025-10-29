import 'package:flutter/material.dart';
import '../../../view/shared/widgets/custom_textfield.dart';
import 'error_text.dart';

class PasswordField extends StatelessWidget {
  final String value;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Password',
          obscureText: true,
          onChanged: enabled ? onChanged : null,
        ),
        if (errorText != null) ErrorText(message: errorText!),
      ],
    );
  }
}

