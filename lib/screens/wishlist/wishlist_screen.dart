import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/mock_wishlist_products.dart';
import '../../models/product.dart';
import '../../widgets/empty_state.dart';
import '../product/widgets/pro_nav_drawer.dart';
import 'widgets/wishlist_item_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<Product> _items;
  final Set<String> _removing = {};

  @override
  void initState() {
    super.initState();
    _items = List.of(mockWishlistProducts); // local mutable copy for UI-first demo
  }

  void _remove(Product product) async {
    setState(() => _removing.add(product.id));
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() {
      _items.removeWhere((p) => p.id == product.id);
      _removing.remove(product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const ProNavDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.secondary,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.primaryFixedDim),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
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
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('Your Favorites', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  'Manage your saved high-performance hardware and gear.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.stackLg),

                if (_items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        const EmptyState(
                          icon: Icons.favorite_border,
                          message: 'No favorites yet — explore our collection and save items for later.',
                        ),
                        const SizedBox(height: AppSpacing.stackLg),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _items = List.of(mockWishlistProducts));
                          },
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('Explore Laptops'),
                        ),
                      ],
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 1100
                          ? 4
                          : constraints.maxWidth >= 800
                              ? 3
                              : constraints.maxWidth >= 500
                                  ? 2
                                  : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: AppSpacing.gutter,
                          crossAxisSpacing: AppSpacing.gutter,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          final product = _items[index];
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: _removing.contains(product.id) ? 0 : 1,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 250),
                              scale: _removing.contains(product.id) ? 0.9 : 1,
                              child: WishlistItemCard(
                                product: product,
                                description: mockWishlistDescriptions[product.id] ?? '',
                                onRemove: () => _remove(product),
                                onAddToCart: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${product.name} added to cart')),
                                  );
                                },
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}