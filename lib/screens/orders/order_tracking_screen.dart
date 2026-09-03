import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../widgets/order_status_badge.dart';
import 'widgets/order_timeline.dart';
import 'widgets/tracking_route_panel.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  static const _productImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCIA0uqYFPAnH7my1XgmZpDwwIfQKGpAqWyw-BAv9Ww2YIXFpKvMnO7Lg9KdqzlGuGhyu-Zpgb2orQHs7eqVPcGHMwUpFADh9a_eIxJ0_qDWDdGnQZoti6hvZVDMTRCAurZEnU_OmGPvLSzJX7F9AbDJ-KtArlKmuvW8VxAZY9hITLXHMxaHZpmpEkOZSRa5opro5CJJ6-7wTsUemQ14BYkbuW6WyJJwzuqecMTOLP-azHxsLWuH7Hm';

  static const _timelineSteps = [
    TimelineStep(
      title: 'Order Shipped',
      subtitle: 'Carrier: GlobalExpress (ID: 77218342)',
      timestamp: 'Today, 10:45 AM',
      isCurrent: true,
    ),
    TimelineStep(
      title: 'Processing Complete',
      subtitle: 'Quality check passed at Warehouse 04',
      timestamp: 'Oct 24, 2026, 03:20 PM',
      isComplete: true,
    ),
    TimelineStep(
      title: 'Order Placed',
      subtitle: 'Payment confirmed via Credit Card',
      timestamp: 'Oct 24, 2026, 09:12 AM',
      isComplete: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.navBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.primaryFixedDim),
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
                icon: const Icon(Icons.search,
                    color: AppColors.primaryFixedDim),
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
                            // Breadcrumb
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall),
                                const Icon(Icons.chevron_right,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant),
                                Text('Order History',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall),
                                const Icon(Icons.chevron_right,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant),
                                Text(
                                  'Track Order',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Track Your Order',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge),
                            const SizedBox(height: 32),

                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth >= 900;
                                final mainCol = _buildMainColumn(context);
                                final sidebar = _buildSidebar(context);

                                if (!isWide) {
                                  return Column(children: [
                                    mainCol,
                                    const SizedBox(height: 24),
                                    sidebar,
                                  ]);
                                }
                                return Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 7, child: mainCol),
                                    const SizedBox(width: 24),
                                    Expanded(flex: 5, child: sidebar),
                                  ],
                                );
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

  Widget _buildMainColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order header card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text('Order #LH-99281-Z',
                        style:
                            Theme.of(context).textTheme.headlineSmall),
                  ),
                  const OrderStatusBadge(status: 'shipped'),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: AppColors.surfaceVariant,
                      child: CachedNetworkImage(
                          imageUrl: _productImage, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TitanBook Pro 16"',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600)),
                        Text(
                            'M2 Ultra Chip, 64GB RAM, 2TB SSD • Space Gray',
                            style:
                                Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const TrackingRoutePanel(
                originLabel: 'Warehouse 04',
                destinationLabel: 'Your Address',
                progress: 0.66,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Timeline
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Progress',
                  style:
                      Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              const OrderTimeline(steps: _timelineSteps),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      children: [
        _infoCard(
          context,
          title: 'Estimated Delivery',
          icon: Icons.event_available_outlined,
          child: Text('Oct 28, 2026',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.primary)),
        ),
        const SizedBox(height: 16),
        _infoCard(
          context,
          title: 'Carrier',
          icon: Icons.local_shipping_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GlobalExpress',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text('Tracking ID: 77218342',
                        style:
                            Theme.of(context).textTheme.bodySmall),
                  ),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                            content: Text('Tracking ID copied'))),
                    child: const Icon(Icons.copy_outlined,
                        size: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _infoCard(
          context,
          title: 'Shipping Address',
          icon: Icons.location_on_outlined,
          child: Text(
            '123 Tech Lane\nSan Francisco, CA 94103',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.onSurface),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.inverseSurface,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Need help with this order?',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.inverseOnSurface)),
              const SizedBox(height: 4),
              Text('Our support team is online.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                          color: AppColors.inverseOnSurface
                              .withValues(alpha: 0.8))),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    minimumSize: const Size(0, 44),
                  ),
                  child: const Text('Chat Now'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(title.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(letterSpacing: 0.8)),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
