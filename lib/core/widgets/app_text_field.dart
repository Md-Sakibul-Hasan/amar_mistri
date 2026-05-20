import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../theme/app_colors.dart';

/// A small bold label displayed above a form field.
class AppFieldLabel extends StatelessWidget {
  final String text;
  const AppFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.colors.primaryText,
      ),
    );
  }
}

/// A styled [TextFormField] that uses [AppTheme.inputDecoration].
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration:
          AppTheme.inputDecoration(
            hint: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ).copyWith(
            fillColor: c.greyInputFill,
            hintStyle: TextStyle(color: c.inputHint, fontSize: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.greyBorder),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.greyBorder),
            ),
          ),
      validator: validator,
    );
  }
}

/// A styled phone number field with a 🇧🇩 +880 country prefix.
///
/// [controller] and [validator] are optional — omit them when the field
/// is used as a UI placeholder (e.g. the phone tab on the login page).
class AppPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AppPhoneField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: c.greyInputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.greyBorder),
      ),
      child: Row(
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇧🇩', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text(
                '+880',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 14, color: Colors.grey),
            ],
          ),
          Container(
            height: 24,
            width: 1,
            color: c.greyBorder,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: '01XXXXXXXXX',
                hintStyle: TextStyle(color: c.inputHint, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
