import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Icon-left text field matching the Stitch login card style.
class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? trailing;
  final Widget? labelTrailing;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.trailing,
    this.labelTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            if (labelTrailing != null) labelTrailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
            suffixIcon: trailing,
          ),
        ),
      ],
    );
  }
}