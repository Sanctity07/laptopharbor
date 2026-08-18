import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../orders/order_tracking_screen.dart';
import '../root_shell.dart';
import 'widgets/confetti_overlay.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;

  // Placeholder order details — TODO: replace with the real OrderModel
  // returned from OrderProvider.placeOrder() once the backend is wired.
  final String _orderNumber = '#LH-${(DateTime.now().millisecondsSinceEpoch % 100000000)}';
  late final DateTime _estimatedDelivery = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _checkScale = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _checkController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _continueShopping() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: ConfettiOverlay()),
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 64,
                  color: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
                  child: Row(
                    children: [
                      const Icon(Icons.menu, color: AppColors.primaryFixedDim),
                      const SizedBox(width: 16),
                      Text(
                        'LaptopHarbor',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryFixedDim,
                              fontSize: 20,
                            ),
                      ),
                      const Spacer(),
                      const Icon(Icons.search, color: AppColors.primaryFixedDim),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.marginMobile),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.stackLg),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8)),
                            ],
                          ),
                          child: Column(
                            children: [
                              ScaleTransition(
                                scale: _checkScale,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                                  child: const Icon(Icons.check_circle, size: 56, color: AppColors.onPrimaryContainer),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.stackLg),
                              Text('Order Confirmed!', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
                              const SizedBox(height: 10),
                              Text(
                                "Thank you for your purchase. We've received your order and our technical team is preparing your high-performance hardware for dispatch.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSpacing.stackLg),

                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth >= 480;
                                  final orderNumberCard = _detailCard(
                                    context,
                                    icon: Icons.receipt_long,
                                    label: 'ORDER NUMBER',
                                    value: _orderNumber,
                                  );
                                  final deliveryCard = _detailCard(
                                    context,
                                    icon: Icons.local_shipping_outlined,
                                    label: 'ESTIMATED DELIVERY',
                                    value: Formatters.date(_estimatedDelivery),
                                  );
                                  if (!isWide) {
                                    return Column(
                                      children: [
                                        orderNumberCard,
                                        const SizedBox(height: AppSpacing.stackMd),
                                        deliveryCard,
                                      ],
                                    );
                                  }
                                  return Row(
                                    children: [
                                      Expanded(child: orderNumberCard),
                                      const SizedBox(width: AppSpacing.gutter),
                                      Expanded(child: deliveryCard),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.stackLg),

                              // Summary preview
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.stackMd),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 76,
                                        height: 76,
                                        color: AppColors.surface,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://lh3.googleusercontent.com/aida-public/AB6AXuChkz4wPcBjUQlItgZZ2Kab_5lTzejxRh0Qcnynf9aEkNJ-IiNKnV_pPWcjCPLv65f5bk_fP4DyXSjN_QABcQI3fxKQf_CfZLD4a7QeWzqTcIPhn17M_i0zWpcHPl42sVPoQMYsQuZdssc-weDbS_GSkATMr553kUgtQYuRbtAlQJU4kKiz7Vgsu0cyqti5K3s6XTag8XtZ3HfAL6JVHY2TML9oRMCZLZbWUfL7sTX4EgQovm6PppmU',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ProStream X-15 Workstation', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w600)),
                                          Text('Intel i9-13900H • 64GB RAM • 2TB SSD', style: Theme.of(context).textTheme.bodySmall),
                                          const SizedBox(height: 2),
                                          Text(Formatters.price(2499), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.stackLg),

                              // Actions
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth >= 480;
                                  final trackBtn = ElevatedButton.icon(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                                    ),
                                    icon: const Icon(Icons.map_outlined, size: 18),
                                    label: const Text('Track Order'),
                                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                                  );
                                  final continueBtn = OutlinedButton.icon(
                                    onPressed: _continueShopping,
                                    icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                                    label: const Text('Continue Shopping'),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 52),
                                      side: const BorderSide(color: AppColors.secondary, width: 2),
                                      foregroundColor: AppColors.secondary,
                                    ),
                                  );
                                  if (!isWide) {
                                    return Column(
                                      children: [
                                        SizedBox(width: double.infinity, child: trackBtn),
                                        const SizedBox(height: AppSpacing.stackMd),
                                        SizedBox(width: double.infinity, child: continueBtn),
                                      ],
                                    );
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      trackBtn,
                                      const SizedBox(width: AppSpacing.stackMd),
                                      continueBtn,
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.stackLg),
                              Text(
                                'A confirmation email has been sent to your registered email address.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.outline,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}