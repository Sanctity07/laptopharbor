import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/mock_listing_products.dart';
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
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String _sortBy = 'Newest First';
  final Set<String> _wishlisted = {};
  // ignore: prefer_final_fields
  List<String> _activeFilters = ['Brand: Razor', 'RAM: 32GB+'];
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialQuery ?? '';
    if (_searchQuery.isNotEmpty) {
      _activeFilters = [_searchQuery, ..._activeFilters];
    }
  }

  void _openDetails(product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = mockListingProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
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
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header
                Text('Pro Laptops', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(
                  'Showing ${products.length} powerful machines for your workflow',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.stackMd),

                // Controls row
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
                            _toggleButton(Icons.grid_view, _isGridMode, () => setState(() => _isGridMode = true)),
                            _toggleButton(Icons.view_list, !_isGridMode, () => setState(() => _isGridMode = false)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filters button
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: const Text('Filters'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          foregroundColor: AppColors.secondary,
                          side: const BorderSide(color: AppColors.outlineVariant),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Sort dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            icon: const Icon(Icons.expand_more, size: 18, color: AppColors.secondary),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary),
                            items: const [
                              DropdownMenuItem(value: 'Newest First', child: Text('Newest First')),
                              DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                              DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                              DropdownMenuItem(value: 'Best Performance', child: Text('Best Performance')),
                            ],
                            onChanged: (value) => setState(() => _sortBy = value ?? _sortBy),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.stackMd),

                // Active filter chips
                if (_activeFilters.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ..._activeFilters.map((filter) => FilterChipPill(
                            label: filter,
                            onRemove: () => setState(() => _activeFilters.remove(filter)),
                          )),
                      TextButton(
                        onPressed: () => setState(() => _activeFilters.clear()),
                        child: const Text('Clear all'),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.stackLg),

                // Product grid/list or empty state
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: EmptyState(icon: Icons.search_off, message: 'No Laptops Found — try adjusting your filters.'),
                  )
                else if (_isGridMode)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 900
                          ? 3
                          : constraints.maxWidth >= 600
                              ? 2
                              : 1;
                      final gap = AppSpacing.stackMd;
                      final cardWidth = crossAxisCount == 1
                          ? constraints.maxWidth
                          : (constraints.maxWidth - gap * (crossAxisCount - 1)) / crossAxisCount;
                      // skeleton tiles appended while loading
                      final itemCount = products.length + (_isLoading ? crossAxisCount : 0);
                      final items = List.generate(itemCount, (index) {
                        if (index >= products.length) {
                          return SizedBox(width: cardWidth, child: const ProductSkeletonCard());
                        }
                        final product = products[index];
                        return SizedBox(
                          width: cardWidth,
                          child: ListingProductCard(
                            product: product,
                            isGridMode: true,
                            isWishlisted: _wishlisted.contains(product.id),
                            onTap: () => _openDetails(product),
                            onWishlistToggle: () => setState(() {
                              _wishlisted.contains(product.id)
                                  ? _wishlisted.remove(product.id)
                                  : _wishlisted.add(product.id);
                            }),
                          ),
                        );
                      });
                      return Wrap(spacing: gap, runSpacing: gap, children: items);
                    },
                  )
                else
                  Column(
                    children: products
                        .map((product) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.stackMd),
                              child: SizedBox(
                                height: 180,
                                child: ListingProductCard(
                                  product: product,
                                  isGridMode: false,
                                  isWishlisted: _wishlisted.contains(product.id),
                                  onTap: () => _openDetails(product),
                                  onWishlistToggle: () => setState(() {
                                    _wishlisted.contains(product.id) ? _wishlisted.remove(product.id) : _wishlisted.add(product.id);
                                  }),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
              ]),
            ),
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
          boxShadow: selected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)] : null,
        ),
        child: Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.secondary),
      ),
    );
  }
}