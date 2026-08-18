import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  String get _initials {
    final parts = review.userName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  String get _relativeTime {
    final diff = DateTime.now().difference(review.createdAt);
    if (diff.inDays >= 14) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays >= 7) return '1 week ago';
    if (diff.inDays >= 1) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return 'Today';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      _initials,
                      style: const TextStyle(color: AppColors.onPrimaryContainer, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(review.userName, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface)),
                ],
              ),
              Text(_relativeTime, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final filled = i < review.rating.round();
              return Icon(filled ? Icons.star : Icons.star_border, size: 16, color: AppColors.tertiary);
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '"${review.comment}"',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}