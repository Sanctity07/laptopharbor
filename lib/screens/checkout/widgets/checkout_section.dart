import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Numbered section card ("1. Shipping Address", "2. Payment Method")
/// matching the Stitch checkout layout.
class CheckoutSection extends StatelessWidget {
  final int number;
  final String title;
  final Widget child;

  const CheckoutSection({
    super.key,
    required this.number,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                child: Text(
                  '$number',
                  style: const TextStyle(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.stackLg),
          child,
        ],
      ),
    );
  }
}