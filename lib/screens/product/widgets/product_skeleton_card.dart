import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';

/// Loading placeholder matching the Stitch `.animate-pulse` skeleton card.
class ProductSkeletonCard extends StatelessWidget {
  const ProductSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceDim,
      highlightColor: AppColors.surfaceContainerLow,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 60, color: AppColors.surfaceDim),
                  const SizedBox(height: 10),
                  Container(height: 18, width: 140, color: AppColors.surfaceDim),
                  const SizedBox(height: 16),
                  Container(height: 10, width: double.infinity, color: AppColors.surfaceDim),
                  const SizedBox(height: 6),
                  Container(height: 10, width: double.infinity, color: AppColors.surfaceDim),
                  const SizedBox(height: 6),
                  Container(height: 10, width: double.infinity, color: AppColors.surfaceDim),
                  const SizedBox(height: 16),
                  Container(height: 40, width: double.infinity, decoration: BoxDecoration(color: AppColors.surfaceDim, borderRadius: BorderRadius.circular(10))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}