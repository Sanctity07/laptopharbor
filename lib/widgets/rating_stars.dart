import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.round();
        return Icon(filled ? Icons.star : Icons.star_border, size: size, color: AppColors.warning);
      }),
    );
  }
}
