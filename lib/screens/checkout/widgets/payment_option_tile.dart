import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.primaryContainer.withOpacity(0.05) : Colors.transparent,
          border: Border.all(color: selected ? AppColors.primary : AppColors.outlineVariant, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: selected ? AppColors.primary : AppColors.secondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? AppColors.primary : AppColors.outlineVariant, width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}