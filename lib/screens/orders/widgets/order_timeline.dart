import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TimelineStep {
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isComplete;
  final bool isCurrent;

  const TimelineStep({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isComplete = false,
    this.isCurrent = false,
  });
}

class OrderTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const OrderTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Dot + line ─────────────────────────────────────────────
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: step.isCurrent
                            ? AppColors.primaryGradient
                            : null,
                        color: step.isComplete
                            ? AppColors.success
                            : step.isCurrent
                                ? null
                                : AppColors.surfaceContainerHigh,
                        border: step.isCurrent
                            ? null
                            : Border.all(
                                color: step.isComplete
                                    ? AppColors.success
                                    : AppColors.outlineVariant,
                                width: 2,
                              ),
                        boxShadow: step.isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: step.isComplete
                          ? const Icon(Icons.check,
                              size: 11, color: Colors.white)
                          : step.isCurrent
                              ? const Icon(Icons.local_shipping_outlined,
                                  size: 11, color: Colors.white)
                              : null,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: step.isComplete
                                  ? [AppColors.success, AppColors.success]
                                  : [
                                      AppColors.outlineVariant,
                                      AppColors.outlineVariant,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // ── Content ────────────────────────────────────────────────
              Expanded(
                child: Opacity(
                  opacity: step.isComplete || step.isCurrent ? 1.0 : 0.45,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: step.isCurrent
                            ? AppColors.primaryContainer
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: step.isCurrent
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: step.isCurrent
                                  ? AppColors.onPrimaryContainer
                                  : AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: step.isCurrent
                                  ? AppColors.onPrimaryContainer
                                      .withValues(alpha: 0.75)
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step.timestamp,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: step.isCurrent
                                  ? AppColors.primary
                                  : AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
