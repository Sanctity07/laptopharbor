import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/responsive.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    SearchScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    final orderProvider = context.read<OrderProvider>();

    final uid = auth.currentUser?.uid;
    productProvider.loadProducts();

    if (uid != null) {
      await Future.wait([
        cartProvider.loadCart(uid),
        wishlistProvider.loadWishlist(uid),
      ]);
      if (!mounted) return;
      orderProvider.listenToOrders(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= Breakpoints.medium;

    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final cartCount = cart.items.length;

        // ── Wide layout: NavigationRail on the left ──────────────────────
        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.navBackground,
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  labelType: NavigationRailLabelType.all,
                  indicatorColor: AppColors.primary.withValues(alpha: 0.18),
                  selectedIconTheme: const IconThemeData(color: AppColors.primaryFixedDim),
                  unselectedIconTheme: const IconThemeData(color: AppColors.primaryFixedDim, opacity: 0.55),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.primaryFixedDim,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        const Icon(Icons.laptop_mac_rounded,
                            color: AppColors.primaryFixedDim, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          'Harbor',
                          style: TextStyle(
                            color: AppColors.primaryFixedDim.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  destinations: [
                    const NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search),
                      label: Text('Search'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Wishlist'),
                    ),
                    NavigationRailDestination(
                      icon: cartCount > 0
                          ? Badge.count(
                              count: cartCount,
                              child: const Icon(Icons.shopping_cart_outlined))
                          : const Icon(Icons.shopping_cart_outlined),
                      selectedIcon: cartCount > 0
                          ? Badge.count(
                              count: cartCount,
                              child: const Icon(Icons.shopping_cart))
                          : const Icon(Icons.shopping_cart),
                      label: const Text('Cart'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.outlineVariant),
                Expanded(
                  child: IndexedStack(index: _index, children: _tabs),
                ),
              ],
            ),
          );
        }

        // ── Narrow layout: bottom NavigationBar ──────────────────────────
        return Scaffold(
          body: IndexedStack(index: _index, children: _tabs),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            indicatorColor: AppColors.primary.withValues(alpha: 0.1),
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home'),
              const NavigationDestination(
                  icon: Icon(Icons.search), label: 'Search'),
              const NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Wishlist'),
              NavigationDestination(
                icon: cartCount == 0
                    ? const Icon(Icons.shopping_cart_outlined)
                    : Badge.count(
                        count: cartCount,
                        child: const Icon(Icons.shopping_cart_outlined)),
                selectedIcon: cartCount == 0
                    ? const Icon(Icons.shopping_cart)
                    : Badge.count(
                        count: cartCount,
                        child: const Icon(Icons.shopping_cart)),
                label: 'Cart',
              ),
              const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
