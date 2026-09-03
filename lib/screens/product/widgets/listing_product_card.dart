import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/product.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: isGridMode ? _gridLayout(context) : _listLayout(context),
      ),
    );
  }

  Widget _gridLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _imageBlock(aspectRatio: 1.2),
        _infoBlock(context),
      ],
    );
  }

  Widget _listLayout(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 140, child: _imageBlock(aspectRatio: 0.9)),
          Expanded(child: _infoBlock(context)),
        ],
      ),
    );
  }

  Widget _imageBlock({required double aspectRatio}) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            color: AppColors.surfaceContainer,
            child: product.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: product.images.first, fit: BoxFit.cover)
                : const Center(
                    child:
                        Icon(Icons.laptop_mac, size: 40, color: AppColors.outline)),
          ),
        ),
        // Badges
        Positioned(
          top: 10,
          left: 10,
          child: Row(
            children: [
              if (product.isNew) _badge('NEW', AppColors.primaryGradient),
              if (product.isNew && product.onSale) const SizedBox(width: 6),
              if (product.onSale)
                _badge(
                    'SALE',
                    const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)])),
            ],
          ),
        ),
        // Wishlist
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onWishlistToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isWishlisted
                    ? AppColors.error.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                    color: isWishlisted
                        ? AppColors.error.withValues(alpha: 0.3)
                        : AppColors.outlineVariant),
              ),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                size: 17,
                color: isWishlisted ? AppColors.error : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBlock(BuildContext context) {
    return Padding(
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
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.price(product.price),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface),
                  ),
                  if (product.onSale)
                    Text(
                      Formatters.price(product.originalPrice!),
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Specs — subtle zebra rows
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: product.specs.entries.take(4).toList().asMap().entries
                  .map((e) {
                final isEven = e.key % 2 == 0;
                final spec = e.value;
                return Container(
                  color: isEven
                      ? Colors.transparent
                      : AppColors.outlineVariant.withValues(alpha: 0.25),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(spec.key,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500)),
                      Text('${spec.value}',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 42),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View Details',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5),
      ),
    );
  }
}
