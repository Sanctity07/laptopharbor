import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final VoidCallback onCheckout;
  final TextEditingController promoController;
  final VoidCallback onApplyPromo;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.onCheckout,
    required this.promoController,
    required this.onApplyPromo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface),
          ),
          const SizedBox(height: 20),

          // Line items
          _line(context, 'Subtotal', Formatters.price(subtotal)),
          const SizedBox(height: 10),
          _line(
            context,
            'Shipping',
            shipping == 0 ? 'FREE' : Formatters.price(shipping),
            valueColor: shipping == 0 ? AppColors.success : null,
          ),
          const SizedBox(height: 10),
          _line(context, 'Tax (7.5%)', Formatters.price(tax)),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: AppColors.outlineVariant),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface)),
              Text(
                Formatters.price(total),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Checkout',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Promo code
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.confirmation_number_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: promoController,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.onSurface),
                    decoration: const InputDecoration(
                      hintText: 'Promo code',
                      border: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onApplyPromo,
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12)),
                  child: const Text('Apply',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Trust badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline,
                  size: 13, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 5),
              Text(
                'Secure & encrypted checkout',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.onSurfaceVariant)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
