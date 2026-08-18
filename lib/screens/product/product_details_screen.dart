import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/mock/mock_listing_products.dart';
import '../../core/mock/mock_reviews.dart';
import '../../models/product.dart';
import 'widgets/spec_table.dart';
import 'widgets/color_swatch_selector.dart';
import 'widgets/review_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _selectedColorIndex = 0;
  bool _isWishlisted = false;

  // Placeholder gallery — the Stitch design shows keyboard/ports/lifestyle
  // detail shots in addition to the hero image.
  static const _galleryImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA-YtemTeHd1QwSVXeJx5Nd_XUDVpvfb81OF1GpV2y6xaQ4QAL6V7MhRPqqbn4EuBe80K0RBDBn3WEzDEtqj5Kqa4QWmce97Dpw-ydxDXYJEx8NHSIUjB55GIRgPIT4zPzBaSg4G9-C1WEwA9NYMl5_divR0bwC2Hon7OZ4BLkq7v0VnVt8rVvO1bp3dNKvb6ODwa4pmB2Odc-XDPj5y5xMBOfVjqdWlRK0V5q3sQz3kS8YT6G7q2Xl',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBKSv_GgQ6BlmXn0o826XepK6QCgRLVDtAaBqsUwvbV7kc7mYvT0JxOFHak55RjxyVV5Pv10xyKd9waqQHb2Fss0CdyAuxNdg-YvqlAYRsfscTgOhupCKAtS_wOdXsgUgGZI1hX4IFZTfGn3FhDMKL8nAtDAaA-G728epGhX_xIIoLI1omwq6Uh5W5L8vjDhTUOhj5gpUGCqX6NNPqhOMd0Zb6PTO7izYGY4yBF0UwBzqQWTfH4bMjp',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCTflfYADI1cLoVJxyrQDcRNhLecdXP3krntLn6bJTWE1y3XfiGdMqTtIQR_pyS6YQxfzs7UUEycC_NYPU4Tzf7n0XpJDbr5phdvVZFhflkpf-JUzs01FbFIQdWibNkqEBNul5oE_SD61NzeUobEuf-tuS_I_9Ewq7pTAqkoTWZXWw07SM6d5Sx6w3VU73L7lN-70FDziuYSk70icGH1ANqWPb5E8ruN2uwJa6sj8Vtno0HcDvgP-Ga',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuASp9qsvIEu9Lh1RnYu1ebGAd77uxhpo7ftNhsw61hG90lyV2gCCjWScq_l4OOWP4LQA5liYpQo9pZilD9ePAY8kvycDejm3v0kSoGBMlOSdHSrctLxNevFtGRSObgftKwJmGXFIGcJKjYLkNYTyYTBRYI7IUQQmVwGdECXjiM05WvvR6MhXOIoFmMXVjc1KmnsHabb2BHcpItmTPbsbs81NGvButJCwMIoRD8BWCapQms8TzPqscgK',
  ];

  static const _finishColors = [Color(0xFF1E293B), Color(0xFFE2E8F0), Color(0xFF0D9488)];

  @override
  Widget build(BuildContext context) {
    final product = widget.product ?? mockListingProducts.first;
    final reviews = mockReviews.where((r) => r.productId == product.id).toList().isNotEmpty
        ? mockReviews.where((r) => r.productId == product.id).toList()
        : mockReviews; // fall back to sample reviews if none match

    final avgRating = reviews.isEmpty
        ? product.rating
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.secondary,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primaryFixedDim),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                title: Text(
                  'LaptopHarbor',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryFixedDim,
                        fontSize: 20,
                      ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: AppColors.primaryFixedDim),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.stackMd,
                  AppSpacing.marginMobile,
                  120, // room for the floating action bar
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Breadcrumbs
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(product.category, style: Theme.of(context).textTheme.labelSmall),
                        const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
                        Text('Professional Series', style: Theme.of(context).textTheme.labelSmall),
                        const Icon(Icons.chevron_right, size: 16, color: AppColors.onSurfaceVariant),
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.stackMd),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 900;
                        final gallery = _buildGallery(product);
                        final info = _buildInfoCard(product, avgRating, reviews.length);

                        if (!isWide) {
                          return Column(children: [gallery, const SizedBox(height: AppSpacing.stackLg), info]);
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: gallery),
                            const SizedBox(width: AppSpacing.gutter),
                            Expanded(flex: 5, child: info),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.stackLg * 1.5),

                    // Reviews section
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.stackLg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer Reviews', style: Theme.of(context).textTheme.headlineMedium),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              i < avgRating.round() ? Icons.star : Icons.star_border,
                                              size: 18,
                                              color: AppColors.tertiary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${avgRating.toStringAsFixed(1)} out of 5',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.onSurface,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  minimumSize: const Size(0, 44),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Write a Review'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.stackLg),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount = constraints.maxWidth >= 900
                                  ? 3
                                  : constraints.maxWidth >= 600
                                      ? 2
                                      : 1;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: AppSpacing.gutter,
                                  crossAxisSpacing: AppSpacing.gutter,
                                  childAspectRatio: 1.3,
                                ),
                                itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // Floating action bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.name} added to cart')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 56)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _isWishlisted = !_isWishlisted),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                          ),
                          child: Icon(
                            _isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: _isWishlisted ? AppColors.error : AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(Product product) {
    final images = product.images.length > 1 ? product.images : _galleryImages;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: AppColors.surfaceContainerLowest,
              padding: const EdgeInsets.all(24),
              child: CachedNetworkImage(
                imageUrl: images[_selectedImageIndex],
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.stackMd),
        Row(
          children: List.generate(images.length, (index) {
            final isSelected = index == _selectedImageIndex;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == images.length - 1 ? 0 : 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = index),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(imageUrl: images[index], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Product product, double avgRating, int reviewCount) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (product.isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'NEW ARRIVAL',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary),
                  ),
                )
              else
                const SizedBox.shrink(),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text('${avgRating.toStringAsFixed(1)}', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface)),
                  const SizedBox(width: 4),
                  Text('($reviewCount Reviews)', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(product.name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(
            'Engineered for creators and developers. Featuring the latest performance architecture and a breathtaking high-resolution display.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.stackLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                Formatters.price(product.price),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontSize: 34),
              ),
              if (product.onSale) ...[
                const SizedBox(width: 10),
                Text(
                  Formatters.price(product.originalPrice!),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.stackLg),
          SpecTable(specs: product.specs.map((k, v) => MapEntry(k, '$v'))),
          const SizedBox(height: AppSpacing.stackLg),
          ColorSwatchSelector(
            colors: _finishColors,
            selectedIndex: _selectedColorIndex,
            onSelected: (index) => setState(() => _selectedColorIndex = index),
          ),
        ],
      ),
    );
  }
}