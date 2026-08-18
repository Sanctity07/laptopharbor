import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final String description;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.description,
    required this.onRemove,
    required this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: const Color(0xFFF1F5F9),
                      padding: const EdgeInsets.all(14),
                      child: product.images.isNotEmpty
                          ? CachedNetworkImage(imageUrl: product.images.first, fit: BoxFit.contain)
                          : const Icon(Icons.laptop_mac, color: AppColors.outline),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                    ),
                  ),
                ),
                if (product.isNew || product.onSale)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: product.onSale ? AppColors.error : AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.onSale
                            ? 'Sale - ${(100 - (product.price / product.originalPrice! * 100)).round()}%'
                            : 'New Arrival',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Formatters.price(product.price), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary)),
                          if (product.onSale)
                            Text(
                              Formatters.price(product.originalPrice!),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}