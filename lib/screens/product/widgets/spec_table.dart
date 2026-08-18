import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Zebra-striped technical spec table matching the Stitch `.spec-row` style.
class SpecTable extends StatelessWidget {
  final Map<String, String> specs;

  const SpecTable({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    final entries = specs.entries.toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'TECHNICAL SPECIFICATIONS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
            for (int i = 0; i < entries.length; i++)
              Container(
                color: i.isEven ? AppColors.surfaceContainerLowest : const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entries[i].key, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                    Text(
                      entries[i].value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}