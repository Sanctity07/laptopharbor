import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product.dart';

/// Product grid card matching the Stitch home page — brand label,
/// heart/wishlist toggle, rating row, price + add-to-cart square button.
class HomeProductCard extends StatelessWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;
  final VoidCallback? onAddToCart;

  const HomeProductCard({
    super.key,
    required this.product,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistToggle,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed image height keeps the card height predictable regardless of card width.
    const double imageHeight = 140;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image ──────────────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: ColoredBox(
                      color: const Color(0xFFF1F5F9),
                      child: product.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.images.first,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.laptop_mac, color: AppColors.outline),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onWishlistToggle,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isWishlisted ? AppColors.error : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Brand ──────────────────────────────────────────────────────
            Text(
              product.brand.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 0.8,
                  ),
            ),

            const SizedBox(height: 2),

            // ── Name ───────────────────────────────────────────────────────
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 4),

            // ── Rating ─────────────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Price + Cart ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    Formatters.price(product.price),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.add_shopping_cart,
                      size: 15,
                      color: AppColors.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}