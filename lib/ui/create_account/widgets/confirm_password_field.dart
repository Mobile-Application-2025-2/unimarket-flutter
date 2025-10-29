import 'package:flutter/material.dart';
import '../../../view/shared/widgets/custom_textfield.dart';
import 'error_text.dart';

class ConfirmPasswordField extends StatelessWidget {
  final String value;
  final String? errorText;
  final bool valid;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const ConfirmPasswordField({
    super.key,
    required this.value,
    required this.valid,
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
          hintText: 'Confirm Password',
          obscureText: true,
          onChanged: enabled ? onChanged : null,
          suffixIcon: value.isNotEmpty && valid && errorText == null
              ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
              : null,
        ),
        if (errorText != null) ErrorText(message: errorText!),
      ],
    );
  }
}

