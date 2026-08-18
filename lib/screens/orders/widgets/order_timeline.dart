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

/// Vertical connected-dot timeline matching the Stitch order tracking design.
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
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.isCurrent
                          ? AppColors.primary
                          : step.isComplete
                              ? AppColors.primary.withOpacity(0.4)
                              : AppColors.surfaceVariant,
                      border: step.isCurrent ? Border.all(color: AppColors.primaryContainer, width: 4) : null,
                    ),
                  ),
                  if (!isLast) Expanded(child: Container(width: 2, color: AppColors.surfaceVariant)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Opacity(
                  opacity: step.isComplete || step.isCurrent ? 1 : 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface)),
                        const SizedBox(height: 2),
                        Text(step.subtitle, style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 2),
                        Text(step.timestamp, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline)),
                      ],
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