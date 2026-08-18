import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/cart_item.dart';

/// Sticky order summary — collapsible item list, totals, Place Order CTA,
/// terms note, and trust badges, matching the Stitch checkout sidebar.
class CheckoutSummaryCard extends StatefulWidget {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final bool isPlacingOrder;
  final VoidCallback onPlaceOrder;

  const CheckoutSummaryCard({
    super.key,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.isPlacingOrder,
    required this.onPlaceOrder,
  });

  @override
  State<CheckoutSummaryCard> createState() => _CheckoutSummaryCardState();
}

class _CheckoutSummaryCardState extends State<CheckoutSummaryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.stackMd),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: AnimatedRotation(
                      turns: _expanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_up, color: AppColors.secondary),
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Column(
                  children: widget.items
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    color: AppColors.surfaceContainerLow,
                                    child: CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.contain),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                                      ),
                                      if (item.subtitle.isNotEmpty)
                                        Text(item.subtitle, style: Theme.of(context).textTheme.labelSmall),
                                      Text(
                                        Formatters.price(item.priceAtAdd),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                secondChild: const SizedBox.shrink(),
              ),
              const Divider(color: AppColors.outlineVariant),
              const SizedBox(height: 8),
              _row(context, 'Subtotal', Formatters.price(widget.subtotal)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping', style: Theme.of(context).textTheme.bodySmall),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      widget.shipping == 0 ? 'FREE' : Formatters.price(widget.shipping),
                      style: const TextStyle(color: AppColors.onPrimaryContainer, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _row(context, 'Estimated Tax', Formatters.price(widget.tax)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.headlineSmall),
                  Text(Formatters.price(widget.total), style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: AppSpacing.stackLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.isPlacingOrder ? null : widget.onPlaceOrder,
                  icon: widget.isPlacingOrder
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Place Order'),
                  label: widget.isPlacingOrder ? const SizedBox.shrink() : const Icon(Icons.arrow_forward, size: 18),
                  iconAlignment: IconAlignment.end,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "By clicking 'Place Order' you agree to our Terms of Service and Privacy Policy. Your transaction is secured with 256-bit SSL encryption.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.gutter),
        Row(
          children: [
            Expanded(child: _trustBadge(context, Icons.verified_user_outlined, '2-Year Warranty')),
            const SizedBox(width: AppSpacing.stackMd),
            Expanded(child: _trustBadge(context, Icons.local_shipping_outlined, 'Next-Day Delivery')),
          ],
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _trustBadge(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}