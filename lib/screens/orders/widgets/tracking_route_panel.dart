import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    size: 17, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                'Package in transit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label(Icons.warehouse_outlined, originLabel,
                  AppColors.primary),
              _label(Icons.home_outlined, destinationLabel,
                  AppColors.tertiary,
                  reverse: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(IconData icon, String text, Color color,
      {bool reverse = false}) {
    final row = [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: reverse ? TextAlign.end : TextAlign.start,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant),
        ),
      ),
    ];
    return Expanded(
      child: Row(
        mainAxisAlignment:
            reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: reverse ? row.reversed.toList() : row,
      ),
    );
  }
}
