import 'package:flutter/material.dart';
import 'package:unimarket/ui/core/ui/custom_textfield.dart';

class PasswordField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final String? errorText;
  final bool obscure;
  final bool visible;
  final VoidCallback? onToggleVisibility;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;

  const PasswordField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscure = true,
    this.visible = false,
    this.onToggleVisibility,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasToggle = onToggleVisibility != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: hintText ?? 'Password',
          obscureText: hasToggle ? !visible : obscure,
          onChanged: enabled ? onChanged : null,
          suffixIcon: hasToggle
              ? IconButton(
                  icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                  onPressed: enabled ? onToggleVisibility : null,
                )
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
