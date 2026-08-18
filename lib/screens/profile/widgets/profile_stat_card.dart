import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
        ],
      ),
    );
  }
}