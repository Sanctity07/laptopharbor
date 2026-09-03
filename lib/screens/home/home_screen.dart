import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/mock/mock_products.dart';
import '../../core/theme/responsive.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
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

  void _openListing() => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProductListingScreen()),
      );

  void _openDetails(Product product) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
      );

  Future<void> _toggleWishlist(String productId) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await context.read<WishlistProvider>().toggle(uid, productId);
  }

  Future<void> _addToCart(Product product) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to add items to your cart.')),
      );
      return;
    }
    await context.read<CartProvider>().addItem(
      uid,
      CartItem(
        productId: product.id,
        name: product.name,
        subtitle: _shortSpec(product),
        imageUrl: product.images.isNotEmpty ? product.images.first : '',
        priceAtAdd: product.price,
        quantity: 1,
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  String _shortSpec(Product p) {
    final ram = p.specs['ram'] ?? p.specs['RAM'] ?? '';
    final storage = p.specs['storage'] ?? p.specs['SSD'] ?? '';
    if (ram.toString().isNotEmpty && storage.toString().isNotEmpty) {
      return '$ram RAM • $storage SSD';
    }
    if (ram.toString().isNotEmpty) return '$ram RAM';
    return p.brand;
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.navBackground,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: screenWidth < Breakpoints.medium
                ? IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.primaryFixedDim),
                    onPressed: () {},
                  )
                : null,
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

          // Responsive sliver padding
          SliverLayoutBuilder(
            builder: (context, sliversConstraints) {
              final w = sliversConstraints.crossAxisExtent;
              final hPad = responsiveHPadding(w);

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Max-width wrapper for ultra-wide screens
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search bar
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
                            const SizedBox(height: 16),

                            // Category chips
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: mockCategories.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final cat = mockCategories[index];
                                  return CategoryChip(
                                    label: cat,
                                    isSelected: cat == _selectedCategory,
                                    onTap: () => setState(() => _selectedCategory = cat),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Deal banner
                            DealBanner(
                              imageUrl:
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBq6VVHOsNbvAF-Re_awQsZDejwLxpLLFZu6waSZu2f50nBhe-5YnQXg-PuyeMJKSvX8a-rorUMtIiXPnjKFaQ9HHF6Owb4hhTGH66VNyYi1rHjvlXNymmt8cSnCXrBiTgZeQLKCk8-z0Gt8fjBtcNigJldE7RLzfqZRQJNr-AXj_nFPElEUdALSHLyHcL-OKBPAHlvyPrYzn1BDh-tNJ7Hc5yJ_kJU-IjywCEjEDsjLnRxjo4benmh',
                              tag: 'EXCLUSIVE DEAL',
                              title: 'Ultima Pro 16',
                              description:
                                  'Experience raw power with the new M3 Max equivalent chip. Save \$400 this week.',
                              onShopNow: _openListing,
                            ),
                            const SizedBox(height: 32),

                            // Trending header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Trending Hardware',
                                    style: Theme.of(context).textTheme.headlineMedium),
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
                            const SizedBox(height: 16),

                            // Responsive product grid: 2 → 3 → 4 columns
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final cw = constraints.maxWidth;
                                final cols = cw >= 1100
                                    ? 4
                                    : cw >= 700
                                        ? 3
                                        : 2;
                                const gap = 16.0;
                                const cardHeight = 292.0;
                                final cardWidth =
                                    (cw - gap * (cols - 1)) / cols;

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: mockProducts.map((p) {
                                    return SizedBox(
                                      width: cardWidth,
                                      height: cardHeight,
                                      child: HomeProductCard(
                                        product: p,
                                        isWishlisted: wishlist.isWishlisted(p.id),
                                        onTap: () => _openDetails(p),
                                        onWishlistToggle: () => _toggleWishlist(p.id),
                                        onAddToCart: () => _addToCart(p),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 32),

                            // Bento promo
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth >= 700;
                                final workstationCard = BentoCard(
                                  imageUrl:
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAsenQNCXAmbLsmMqinA6fID_57DKqZTSSZZvvZcA32wHAntLdbGGqKRW5lWX01ECo8eBASSBlu1pXHf5wNzDYzyfE3wH_WnRqD4XTual6UDQ-5oiL8tDPmKvh_N-CH-uvgU91nwEt4sVm9QSoPel2NmFlgNcteN2hJfX-9dZy3rLULOH0t3sIhDbCCTQE_5WKqCWRiLsdszLRFSxf70yTyfJb4kJ2tCryHrTCnLOr6tGV_NyNU6DKf',
                                  title: 'The Workstation Revolution',
                                  description: 'Precision 7000 Series now available for preorder.',
                                  action: ElevatedButton(
                                    onPressed: _openListing,
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
                                  return Column(children: [
                                    workstationCard,
                                    const SizedBox(height: 24),
                                    gearCard,
                                  ]);
                                }
                                return Row(children: [
                                  Expanded(flex: 2, child: workstationCard),
                                  const SizedBox(width: 24),
                                  Expanded(child: gearCard),
                                ]);
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
