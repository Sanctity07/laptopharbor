import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../models/cart_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/empty_state.dart';
import '../checkout/checkout_screen.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/order_summary_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _increment(CartItem item) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await context.read<CartProvider>().addItem(
      uid,
      CartItem(
        productId: item.productId,
        name: item.name,
        subtitle: item.subtitle,
        imageUrl: item.imageUrl,
        priceAtAdd: item.priceAtAdd,
        quantity: 1,
      ),
    );
  }

  Future<void> _decrement(CartItem item) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    final cart = context.read<CartProvider>();
    if (item.quantity <= 1) {
      await cart.removeItem(uid, item.productId);
    } else {
      await cart.updateItem(
        uid,
        CartItem(
          productId: item.productId,
          name: item.name,
          subtitle: item.subtitle,
          imageUrl: item.imageUrl,
          priceAtAdd: item.priceAtAdd,
          quantity: item.quantity - 1,
        ),
      );
    }
  }

  Future<void> _remove(CartItem item) async {
    final uid = context.read<AuthProvider>().currentUser?.uid;
    if (uid == null) return;
    await context.read<CartProvider>().removeItem(uid, item.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final items = cart.items;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.navBackground,
                elevation: 0,
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
                            child: _buildBody(context, cart, items, w),
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

  Widget _buildBody(
      BuildContext context, CartProvider cart, List<CartItem> items, double w) {
    if (cart.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: EmptyState(
          icon: Icons.shopping_cart_outlined,
          message: 'Your cart is empty — go find something great.',
        ),
      );
    }

    final isWide = w >= Breakpoints.medium;

    final itemsList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Shopping Cart (${items.length} Item${items.length == 1 ? '' : 's'})',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CartItemCard(
                item: item,
                onIncrement: () => _increment(item),
                onDecrement: () => _decrement(item),
                onRemove: () => _remove(item),
              ),
            )),
      ],
    );

    final summary = Column(
      children: [
        OrderSummaryCard(
          subtotal: cart.subtotal,
          tax: cart.tax,
          shipping: cart.shipping,
          total: cart.total,
          promoController: _promoController,
          onApplyPromo: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Promo codes coming soon')),
            );
          },
          onCheckout: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CheckoutScreen()),
          ),
        ),
        if (isWide) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.support_agent,
                      color: AppColors.onPrimaryContainer, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Need help?',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.onSurface)),
                      Text('Chat with a Pro expert anytime.',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );

    if (!isWide) {
      return Column(
        children: [itemsList, const SizedBox(height: 32), summary],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: itemsList),
        const SizedBox(width: 24),
        Expanded(flex: 4, child: summary),
      ],
    );
  }
}
