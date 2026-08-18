import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
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
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.stackMd),
          _row(context, 'Subtotal', Formatters.price(subtotal)),
          const SizedBox(height: 10),
          _row(context, 'Estimated Shipping', shipping == 0 ? 'FREE' : Formatters.price(shipping), highlight: shipping == 0),
          const SizedBox(height: 10),
          _row(context, 'Tax (7.5%)', Formatters.price(tax)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.outlineVariant, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.headlineSmall),
              Text(
                Formatters.price(total),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackLg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCheckout,
              icon: const Text('Proceed to Checkout'),
              label: const Icon(Icons.arrow_forward, size: 18),
              iconAlignment: IconAlignment.end,
            ),
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline, style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, color: AppColors.tertiary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: promoController,
                    decoration: const InputDecoration(
                      hintText: 'Promo Code',
                      border: InputBorder.none,
                      isDense: true,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onApplyPromo,
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text('Secure checkout by LaptopHarbor Pay', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: highlight ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}