import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product.dart';

/// Product card for the listing grid/list — badges, spec rows
/// (zebra-striped like the Stitch design), price + strikethrough,
/// and a "View Details" CTA. `isGridMode` toggles column vs row layout.
class ListingProductCard extends StatelessWidget {
  final Product product;
  final bool isGridMode;
  final bool isWishlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistToggle;

  const ListingProductCard({
    super.key,
    required this.product,
    this.isGridMode = true,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final image = Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            color: AppColors.surfaceContainerLow,
            child: product.images.isNotEmpty
                ? CachedNetworkImage(imageUrl: product.images.first, fit: BoxFit.cover)
                : const Icon(Icons.laptop_mac, color: AppColors.outline),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Row(
            children: [
              if (product.isNew) _badge(context, 'NEW', AppColors.secondary),
              if (product.isNew && product.onSale) const SizedBox(width: 6),
              if (product.onSale) _badge(context, 'SALE', AppColors.primary),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onWishlistToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: isWishlisted ? AppColors.error : AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
    );

    final details = Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                      product.brand.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary),
                    ),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.price(product.price),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                  if (product.onSale)
                    Text(
                      Formatters.price(product.originalPrice!),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: AppColors.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: product.specs.entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.key, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
                            Text(
                              '${e.value}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Text('View Details'),
              label: const Icon(Icons.arrow_forward, size: 16),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );

    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: isGridMode
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [image, details],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 140, child: image),
                    Expanded(child: details),
                  ],
                ),
              ),
            ),
    );

    return GestureDetector(onTap: onTap, child: card);
  }

  Widget _badge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}