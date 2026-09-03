import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SpecTable extends StatelessWidget {
  final Map<String, String> specs;

  const SpecTable({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    final entries = specs.entries.toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: AppColors.navBackground,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: const Text(
                'TECHNICAL SPECIFICATIONS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.navForeground,
                ),
              ),
            ),
            // Rows
            ...List.generate(entries.length, (i) {
              final isEven = i % 2 == 0;
              return Container(
                color: isEven
                    ? AppColors.surfaceContainerLowest
                    : AppColors.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entries[i].key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        entries[i].value,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
