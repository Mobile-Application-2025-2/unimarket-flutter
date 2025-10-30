import 'package:flutter/material.dart';
import 'package:unimarket/ui/core/ui/custom_textfield.dart';

class ConfirmPasswordField extends StatelessWidget {
  final String value;
  final String? errorText;
  final bool valid;
  final ValueChanged<String> onChanged;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  const ConfirmPasswordField({
    super.key,
    required this.value,
    required this.valid,
    required this.onChanged,
    this.errorText,
    this.textInputAction,
    this.focusNode,
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
          // CustomTextField currently doesn't expose textInputAction/focusNode
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
      ],
    );
  }
}
