import 'package:flutter/material.dart';
import '../../../view/shared/widgets/custom_textfield.dart';
import 'error_text.dart';

class EmailField extends StatelessWidget {
  final String value;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const EmailField({
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
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          onChanged: enabled ? onChanged : null,
          suffixIcon: value.isNotEmpty && errorText == null
              ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
              : null,
        ),
        if (errorText != null) ErrorText(message: errorText!),
      ],
    );
  }
}

