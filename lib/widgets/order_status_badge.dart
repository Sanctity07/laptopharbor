import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  _Config get _config {
    switch (status.toLowerCase()) {
      case 'delivered':
        return _Config(AppColors.success, AppColors.successContainer,
            Icons.check_circle_outline_rounded);
      case 'shipped':
        return _Config(AppColors.primary, AppColors.primaryContainer,
            Icons.local_shipping_outlined);
      case 'processing':
        return _Config(AppColors.warning, AppColors.warningContainer,
            Icons.autorenew_rounded);
      case 'cancelled':
        return _Config(AppColors.error, AppColors.errorContainer,
            Icons.cancel_outlined);
      default: // placed
        return _Config(AppColors.secondary, AppColors.secondaryContainer,
            Icons.receipt_long_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _config;
    final label = status[0].toUpperCase() + status.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cfg.icon, size: 13, color: cfg.fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: cfg.fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Config {
  final Color fg;
  final Color bg;
  final IconData icon;
  const _Config(this.fg, this.bg, this.icon);
}
