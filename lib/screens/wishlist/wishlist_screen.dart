import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/mock/mock_products.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/empty_state.dart';
import '../product/widgets/pro_nav_drawer.dart';
import 'widgets/wishlist_item_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlist, cart, _) {
        final wishlistedProducts = mockProducts
            .where((p) => wishlist.productIds.contains(p.id))
            .toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: const ProNavDrawer(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.navBackground,
                elevation: 0,
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.primaryFixedDim),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
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

              SliverLayoutBuilder(
                builder: (context, sc) {
                  final w = sc.crossAxisExtent;
                  final hPad = responsiveHPadding(w);
                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1280),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Your Favorites',
                                    style: Theme.of(context).textTheme.headlineLarge),
                                const SizedBox(height: 4),
                                Text(
                                  'Manage your saved high-performance hardware and gear.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 32),

                                if (wishlistedProducts.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 60),
                                    child: EmptyState(
                                      icon: Icons.favorite_border,
                                      message:
                                          'No favorites yet — explore our collection and save items for later.',
                                    ),
                                  )
                                else
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final cols = constraints.maxWidth >= 1100
                                          ? 4
                                          : constraints.maxWidth >= 800
                                              ? 3
                                              : constraints.maxWidth >= 500
                                                  ? 2
                                                  : 1;
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: wishlistedProducts.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          mainAxisSpacing: 24,
                                          crossAxisSpacing: 24,
                                          childAspectRatio: 0.62,
                                        ),
                                        itemBuilder: (context, index) {
                                          final p = wishlistedProducts[index];
                                          return WishlistItemCard(
                                            product: p,
                                            description: _shortSpec(p),
                                            onRemove: () =>
                                                _removeFromWishlist(context, p),
                                            onAddToCart: () =>
                                                _addToCart(context, cart, p),
                                            onTap: () {},
                                          );
                                        },
                                      );
                                    },
                                  ),
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
      },
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

  Future<void> _removeFromWishlist(BuildContext context, Product product) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await context.read<WishlistProvider>().toggle(uid, product.id);
  }

  Future<void> _addToCart(
      BuildContext context, CartProvider cart, Product product) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await cart.addItem(
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
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }
}
