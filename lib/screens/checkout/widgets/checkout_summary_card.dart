import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/cart_item.dart';

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
        // Main card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant),
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: AnimatedRotation(
                      turns: _expanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.keyboard_arrow_up,
                            size: 18, color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],
              ),

              // Items list
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                        children: [
                          const SizedBox(height: 16),
                          ...widget.items.map((item) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      child: Container(
                                        width: 52,
                                        height: 52,
                                        color: AppColors.surfaceContainer,
                                        child: CachedNetworkImage(
                                            imageUrl: item.imageUrl,
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.onSurface),
                                          ),
                                          if (item.subtitle.isNotEmpty)
                                            Text(item.subtitle,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors
                                                        .onSurfaceVariant)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      Formatters.price(
                                          item.priceAtAdd * item.quantity),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, color: AppColors.outlineVariant),
              ),

              // Line items
              _line('Subtotal', Formatters.price(widget.subtotal)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shipping',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.onSurfaceVariant)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.successContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.shipping == 0
                          ? 'FREE'
                          : Formatters.price(widget.shipping),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _line('Tax', Formatters.price(widget.tax)),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
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
                    Formatters.price(widget.total),
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
                  onPressed:
                      widget.isPlacingOrder ? null : widget.onPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: widget.isPlacingOrder
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline, size: 15),
                            SizedBox(width: 8),
                            Text('Place Order',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Protected by 256-bit SSL encryption',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Trust badges
        Row(
          children: [
            Expanded(
                child: _badge(
                    Icons.verified_user_outlined, '2-Year\nWarranty')),
            const SizedBox(width: 12),
            Expanded(
                child:
                    _badge(Icons.local_shipping_outlined, 'Next-Day\nDelivery')),
          ],
        ),
      ],
    );
  }

  Widget _line(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.onSurfaceVariant)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface)),
      ],
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  height: 1.3)),
        ],
      ),
    );
  }
}
