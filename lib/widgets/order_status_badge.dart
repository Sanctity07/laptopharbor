import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status; // placed | processing | shipped | delivered

  const OrderStatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'delivered':
        return AppColors.success;
      case 'shipped':
        return AppColors.primary;
      case 'processing':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: _color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(status[0].toUpperCase() + status.substring(1),
          style: TextStyle(color: _color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
