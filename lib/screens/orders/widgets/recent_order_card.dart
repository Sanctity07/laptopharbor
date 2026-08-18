import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../widgets/order_status_badge.dart';

class RecentOrderCard extends StatelessWidget {
  final String date;
  final String orderNumber;
  final String status; // placed | processing | shipped | delivered
  final String imageUrl;
  final String itemSummary;
  final double price;
  final VoidCallback onTap;

  const RecentOrderCard({
    super.key,
    required this.date,
    required this.orderNumber,
    required this.status,
    required this.imageUrl,
    required this.itemSummary,
    required this.price,
    required this.onTap,
  });

  Color get _accentColor {
    switch (status) {
      case 'delivered':
        return AppColors.success;
      case 'processing':
        return AppColors.tertiary;
      case 'shipped':
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: _accentColor, width: 4)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date, style: Theme.of(context).textTheme.labelSmall),
                      Text(orderNumber, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface)),
                    ],
                  ),
                  OrderStatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 48,
                      height: 48,
                      color: AppColors.surfaceVariant,
                      child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(itemSummary, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                        Text(Formatters.price(price), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.outline),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}