import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/product.dart';

/// TODO: Replace styling below with the Stitch-generated ProductCard design.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onWishlistToggle,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: product.images.isNotEmpty
                        ? CachedNetworkImage(imageUrl: product.images.first, fit: BoxFit.cover)
                        : Container(color: AppColors.border),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.accent),
                    onPressed: onWishlistToggle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(Formatters.price(product.price),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      Text(' \${product.rating.toStringAsFixed(1)} (\${product.reviewCount})',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
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
