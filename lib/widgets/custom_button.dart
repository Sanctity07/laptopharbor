import 'package:flutter/material.dart';

/// TODO: Style to match Stitch design (colors already come from AppTheme).
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20, width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Text(label);

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: child)
          : ElevatedButton(onPressed: isLoading ? null : onPressed, child: child),
    );
  }
}
