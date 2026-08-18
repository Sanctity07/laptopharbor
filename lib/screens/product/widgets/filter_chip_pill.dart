import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FilterChipPill extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterChipPill({super.key, required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryContainer),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: AppColors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}