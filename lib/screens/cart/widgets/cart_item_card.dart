import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 100,
              height: 100,
              color: const Color(0xFFF1F5F9),
              child: CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
                          ),
                          if (item.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(item.subtitle, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      Formatters.price(item.priceAtAdd),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          _stepperButton(Icons.remove, onDecrement),
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface),
                            ),
                          ),
                          _stepperButton(Icons.add, onIncrement),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      label: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.error),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}