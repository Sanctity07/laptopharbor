import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Stylized origin → destination progress panel, standing in for a live
/// map until real carrier/map integration is wired up.
class TrackingRoutePanel extends StatelessWidget {
  final String originLabel;
  final String destinationLabel;
  final double progress; // 0.0–1.0

  const TrackingRoutePanel({
    super.key,
    required this.originLabel,
    required this.destinationLabel,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryContainer.withOpacity(0.08), AppColors.tertiaryContainer.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Live tracking map coming soon', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.warehouse_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(originLabel, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        destinationLabel,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.home_outlined, size: 16, color: AppColors.tertiary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}