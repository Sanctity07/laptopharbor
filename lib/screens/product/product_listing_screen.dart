import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/mock/mock_listing_products.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/empty_state.dart';
import 'product_details_screen.dart';
import 'widgets/filter_chip_pill.dart';
import 'widgets/listing_product_card.dart';
import 'widgets/product_skeleton_card.dart';

class ProductListingScreen extends StatefulWidget {
  final String? initialQuery;

  const ProductListingScreen({super.key, this.initialQuery});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  bool _isGridMode = true;
  bool _isLoading = false; // ignore: prefer_final_fields
  String _sortBy = 'Newest First';
  List<String> _activeFilters = ['Brand: Razor', 'RAM: 32GB+']; // ignore: prefer_final_fields
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery ?? '';
    if (_searchQuery.isNotEmpty) {
      _activeFilters = [_searchQuery, ..._activeFilters];
    }
  }

  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
  }

  Future<void> _toggleWishlist(String productId) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await context.read<WishlistProvider>().toggle(uid, productId);
  }

  @override
  Widget build(BuildContext context) {
    final products = mockListingProducts;
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.navBackground,
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
                            // ── Header ────────────────────────────────────
                            Text('Pro Laptops',
                                style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 2),
                            Text(
                              'Showing ${products.length} powerful machines for your workflow',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),

                            // ── Controls row ─────────────────────────────
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Grid/list toggle
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        _toggleButton(Icons.grid_view, _isGridMode,
                                            () => setState(() => _isGridMode = true)),
                                        _toggleButton(Icons.view_list, !_isGridMode,
                                            () => setState(() => _isGridMode = false)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.filter_list, size: 18),
                                    label: const Text('Filters'),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 44),
                                      foregroundColor: AppColors.navForeground,
                                      side: const BorderSide(
                                          color: AppColors.outlineVariant),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.outlineVariant),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _sortBy,
                                        icon: const Icon(Icons.expand_more,
                                            size: 18,
                                            color: AppColors.navForeground),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: AppColors.navForeground),
                                        items: const [
                                          DropdownMenuItem(
                                              value: 'Newest First',
                                              child: Text('Newest First')),
                                          DropdownMenuItem(
                                              value: 'Price: Low to High',
                                              child: Text('Price: Low to High')),
                                          DropdownMenuItem(
                                              value: 'Price: High to Low',
                                              child: Text('Price: High to Low')),
                                          DropdownMenuItem(
                                              value: 'Best Performance',
                                              child: Text('Best Performance')),
                                        ],
                                        onChanged: (v) => setState(
                                            () => _sortBy = v ?? _sortBy),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── Active filters ────────────────────────────
                            if (_activeFilters.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ..._activeFilters.map((f) => FilterChipPill(
                                        label: f,
                                        onRemove: () => setState(
                                            () => _activeFilters.remove(f)),
                                      )),
                                  TextButton(
                                    onPressed: () =>
                                        setState(() => _activeFilters.clear()),
                                    child: const Text('Clear all'),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 32),

                            // ── Product grid / list ───────────────────────
                            if (products.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: EmptyState(
                                    icon: Icons.search_off,
                                    message:
                                        'No Laptops Found — try adjusting your filters.'),
                              )
                            else if (_isGridMode)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final cw = constraints.maxWidth;
                                  // Responsive columns: 1 → 2 → 3 → 4
                                  final cols = cw >= 1100
                                      ? 4
                                      : cw >= 900
                                          ? 3
                                          : cw >= 600
                                              ? 2
                                              : 1;
                                  const gap = 16.0;
                                  final cardWidth = cols == 1
                                      ? cw
                                      : (cw - gap * (cols - 1)) / cols;
                                  final itemCount = products.length +
                                      (_isLoading ? cols : 0);
                                  final items =
                                      List.generate(itemCount, (index) {
                                    if (index >= products.length) {
                                      return SizedBox(
                                          width: cardWidth,
                                          child: const ProductSkeletonCard());
                                    }
                                    final p = products[index];
                                    return SizedBox(
                                      width: cardWidth,
                                      child: ListingProductCard(
                                        product: p,
                                        isGridMode: true,
                                        isWishlisted:
                                            wishlist.isWishlisted(p.id),
                                        onTap: () => _openDetails(p),
                                        onWishlistToggle: () =>
                                            _toggleWishlist(p.id),
                                      ),
                                    );
                                  });
                                  return Wrap(
                                      spacing: gap,
                                      runSpacing: gap,
                                      children: items);
                                },
                              )
                            else
                              Column(
                                children: products
                                    .map((p) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16),
                                          child: SizedBox(
                                            height: 180,
                                            child: ListingProductCard(
                                              product: p,
                                              isGridMode: false,
                                              isWishlisted:
                                                  wishlist.isWishlisted(p.id),
                                              onTap: () => _openDetails(p),
                                              onWishlistToggle: () =>
                                                  _toggleWishlist(p.id),
                                            ),
                                          ),
                                        ))
                                    .toList(),
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
  }

  Widget _toggleButton(IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4)
                ]
              : null,
        ),
        child: Icon(icon,
            size: 20,
            color: selected ? AppColors.primary : AppColors.secondary),
      ),
    );
  }
}
