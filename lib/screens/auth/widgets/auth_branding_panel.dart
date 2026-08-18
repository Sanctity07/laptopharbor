import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Desktop-only left panel (mirrors the `hidden lg:flex` section in the
/// Stitch HTML). Only shown by the screens when width >= 1024.
class AuthBrandingPanel extends StatelessWidget {
  const AuthBrandingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.stackLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.laptop_mac_rounded, color: AppColors.primary, size: 36),
              const SizedBox(width: 8),
              Text(
                'LaptopHarbor',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMd),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 40,
                    height: 1.15,
                    color: AppColors.onSurface,
                  ),
              children: const [
                TextSpan(text: 'Engineered for '),
                TextSpan(text: 'Performance.', style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.stackSm),
          Text(
            'Join the premier community for tech professionals and hardware enthusiasts. '
            'High-performance gear, verified specs, and expert support.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.stackLg),
          Row(
            children: [
              Expanded(child: _FeatureCard(icon: Icons.verified_user, title: 'Secure Login', desc: '256-bit encryption for all your data.')),
              const SizedBox(width: AppSpacing.stackMd),
              Expanded(child: _FeatureCard(icon: Icons.bolt, title: 'Instant Sync', desc: 'Access your wishlist across all devices.')),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(desc, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}