import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/mock/mock_cart_items.dart';
import '../../models/cart_item.dart';
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
  late List<CartItem> _items;
  final _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.of(mockCartItems); // local mutable copy for UI-first demo
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);
  double get _shipping => _items.isEmpty ? 0 : 0; // FREE, matching the design
  double get _tax => _subtotal * 0.075;
  double get _total => _subtotal + _shipping + _tax;

  void _increment(CartItem item) => setState(() => item.quantity++);

  void _decrement(CartItem item) => setState(() {
        if (item.quantity > 1) item.quantity--;
      });

  void _remove(CartItem item) => setState(() => _items.remove(item));

  @override
  Widget build(BuildContext context) {
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
                if (_items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: EmptyState(icon: Icons.shopping_cart_outlined, message: 'Your cart is empty — go find something great.'),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 900;
                      final itemsList = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Shopping Cart (${_items.length} Items)',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppSpacing.stackMd),
                          ..._items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.stackMd),
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
                            subtotal: _subtotal,
                            tax: _tax,
                            shipping: _shipping,
                            total: _total,
                            promoController: _promoController,
                            onApplyPromo: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Promo codes coming soon')),
                              );
                            },
                            onCheckout: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                          ),
                          if (isWide) ...[
                            const SizedBox(height: AppSpacing.gutter),
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
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.support_agent, color: AppColors.onPrimaryContainer, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Need help?', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.onSurface)),
                                        Text('Chat with a Pro expert anytime.', style: Theme.of(context).textTheme.bodySmall),
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
                          children: [
                            itemsList,
                            const SizedBox(height: AppSpacing.stackLg),
                            summary,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: itemsList),
                          const SizedBox(width: AppSpacing.gutter),
                          Expanded(flex: 4, child: summary),
                        ],
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