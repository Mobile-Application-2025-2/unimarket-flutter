import 'package:flutter/material.dart';
import 'package:unimarket/ui/core/ui/custom_textfield.dart';

class EmailField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  const EmailField({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.errorText,
    this.suffixIcon,
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
          hintText: hintText ?? 'Email',
          keyboardType: TextInputType.emailAddress,
          onChanged: enabled ? onChanged : null,
          suffixIcon: suffixIcon ?? (value.isNotEmpty && errorText == null
              ? const Icon(Icons.check_circle, color: Color(0xFFFFC436), size: 20)
              : null),
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
