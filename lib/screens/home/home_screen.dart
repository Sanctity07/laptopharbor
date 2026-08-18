import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/mock_products.dart';
import '../product/product_details_screen.dart';
import '../product/product_listing_screen.dart';
import 'widgets/category_chip.dart';
import 'widgets/deal_banner.dart';
import 'widgets/home_product_card.dart';
import 'widgets/bento_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Laptops';
  final Set<String> _wishlisted = {};

  void _openListing() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProductListingScreen()),
    );
  }

  void _openDetails(product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Top app bar (secondary-toned, matches the Stitch header)
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.secondary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryFixedDim),
              onPressed: () {},
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
                onPressed: _openListing,
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search bar — tapping pushes to the product listing screen
                GestureDetector(
                  onTap: _openListing,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(Icons.search, color: AppColors.outline, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search for performance...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
                          ),
                        ),
                        const Icon(Icons.mic_none, color: AppColors.outline, size: 20),
                        const SizedBox(width: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.stackMd),

                // Category chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: mockCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = mockCategories[index];
                      return CategoryChip(
                        label: category,
                        isSelected: category == _selectedCategory,
                        onTap: () => setState(() => _selectedCategory = category),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Featured deal banner
                DealBanner(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBq6VVHOsNbvAF-Re_awQsZDejwLxpLLFZu6waSZu2f50nBhe-5YnQXg-PuyeMJKSvX8a-rorUMtIiXPnjKFaQ9HHF6Owb4hhTGH66VNyYi1rHjvlXNymmt8cSnCXrBiTgZeQLKCk8-z0Gt8fjBtcNigJldE7RLzfqZRQJNr-AXj_nFPElEUdALSHLyHcL-OKBPAHlvyPrYzn1BDh-tNJ7Hc5yJ_kJU-IjywCEjEDsjLnRxjo4benmh',
                  tag: 'EXCLUSIVE DEAL',
                  title: 'Ultima Pro 16',
                  description: 'Experience raw power with the new M3 Max equivalent chip. Save \$400 this week.',
                  onShopNow: () {},
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Trending Hardware header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trending Hardware', style: Theme.of(context).textTheme.headlineMedium),
                    TextButton(
                      onPressed: _openListing,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('View All'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackMd),

                // Product grid — fixed mainAxisExtent avoids childAspectRatio fragility
                LayoutBuilder(
                  builder: (context, constraints) {
                    const double gap = AppSpacing.stackMd;
                    const double cardHeight = 292; // image(140)+spacers+brand+name+rating+price row
                    final cardWidth = (constraints.maxWidth - gap) / 2;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: mockProducts.map((product) {
                        return SizedBox(
                          width: cardWidth,
                          height: cardHeight,
                          child: HomeProductCard(
                            product: product,
                            isWishlisted: _wishlisted.contains(product.id),
                            onTap: () => _openDetails(product),
                            onWishlistToggle: () {
                              setState(() {
                                if (_wishlisted.contains(product.id)) {
                                  _wishlisted.remove(product.id);
                                } else {
                                  _wishlisted.add(product.id);
                                }
                              });
                            },
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.name} added to cart')),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Bento promo section
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;
                    final workstationCard = BentoCard(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAsenQNCXAmbLsmMqinA6fID_57DKqZTSSZZvvZcA32wHAntLdbGGqKRW5lWX01ECo8eBASSBlu1pXHf5wNzDYzyfE3wH_WnRqD4XTual6UDQ-5oiL8tDPmKvh_N-CH-uvgU91nwEt4sVm9QSoPel2NmFlgNcteN2hJfX-9dZy3rLULOH0t3sIhDbCCTQE_5WKqCWRiLsdszLRFSxf70yTyfJb4kJ2tCryHrTCnLOr6tGV_NyNU6DKf',
                      title: 'The Workstation Revolution',
                      description: 'Precision 7000 Series now available for preorder.',
                      action: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.onSurface,
                          minimumSize: const Size(0, 40),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text('Learn More'),
                        ),
                      ),
                    );
                    final gearCard = BentoCard(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD4JJrupMJiw5Sk4b56GdQqaNy8R82yO2AupsNuWCbsMyK5354hA_B4zCt9EvEY95hYeXll6NeYKy8AeJlp2TnPCq-fWgEZ-8l62t1VQUIiNo8tw5fj7ueAe7vrBOcJEIKH00SYfDoJZ8VCTZynRnAFHbaIvDCLNx7jUVolLksSmLw3OhdHwdtWYsBI7iT5jLTiJZJqKmsvGH1xqDWEsXEV8l_XBHbZ262TdKZoz0q6t7IVGEy9UDTi',
                      title: 'Gear Up',
                      description: 'Up to 30% off accessories.',
                      contentAlignment: Alignment.bottomLeft,
                    );

                    if (!isWide) {
                      return Column(
                        children: [
                          workstationCard,
                          const SizedBox(height: AppSpacing.gutter),
                          gearCard,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(flex: 2, child: workstationCard),
                        const SizedBox(width: AppSpacing.gutter),
                        Expanded(child: gearCard),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.stackLg),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}