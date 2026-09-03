import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import 'order_tracking_screen.dart';
import 'widgets/order_timeline.dart';
import 'widgets/recent_order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const _activeOrderImage =
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
            backgroundColor: AppColors.secondary,
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
                            Row(
                              children: [
                                Text('Account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall),
                                const Icon(Icons.chevron_right,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant),
                                Text(
                                  'Order History',
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
                            Text('Your Orders',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge),
                            const SizedBox(height: 32),

                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth >= 900;

                                final activeOrderCard =
                                    _buildActiveOrderCard(context);
                                final recentHistory =
                                    _buildRecentHistory(context);

                                if (!isWide) {
                                  return Column(
                                    children: [
                                      activeOrderCard,
                                      const SizedBox(height: 24),
                                      recentHistory,
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 7, child: activeOrderCard),
                                    const SizedBox(width: 24),
                                    Expanded(
                                        flex: 5, child: recentHistory),
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

  Widget _buildActiveOrderCard(BuildContext context) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT SHIPMENT',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(letterSpacing: 1)),
                    Text('Order #LH-99281-Z',
                        style:
                            Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(999)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 16,
                          color: AppColors.onPrimaryContainer),
                      const SizedBox(width: 6),
                      Text('Shipped',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: AppColors.onPrimaryContainer)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, inner) {
                final isWide = inner.maxWidth >= 420;
                final image = ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: isWide ? 128 : double.infinity,
                    height: 128,
                    color: AppColors.surfaceVariant,
                    child: CachedNetworkImage(
                        imageUrl: _activeOrderImage,
                        fit: BoxFit.cover),
                  ),
                );
                final details = Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TitanBook Pro 16"',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                          'M2 Ultra Chip, 64GB RAM, 2TB SSD • Space Gray',
                          style:
                              Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 14),
                      const OrderTimeline(steps: _timelineSteps),
                    ],
                  ),
                );
                if (!isWide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      image,
                      const SizedBox(height: 16),
                      details
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image,
                    const SizedBox(width: 16),
                    details
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const OrderTrackingScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    minimumSize: const Size(0, 44),
                  ),
                  child: const Text('Track Shipment'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 44)),
                  child: const Text('Order Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent History',
                style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14)
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RecentOrderCard(
          date: 'Oct 12, 2026',
          orderNumber: '#LH-88312-A',
          status: 'delivered',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDCQlg--h6ratGNfaYv8RlUbUBC7gMjBsaUyXcxugMFNt1tqb-934_w8CVjyX8uEqB1ZQ1LwvYxvATEA6YtYWMi_wfFRNInJ808279_H-DnRpMAdIEMFWMbHk5XGEmws6JHXPhXpGUdbbcuxkiWukgfUOIfJ-DQvlUjdlk3IbSJsf02j0hnDySo1B_EmTXqa9lXOIveSbUNsDmKOPzNyULTzbtqN69IV_9hpGdH7Tsohxqi_6TwFj9j',
          itemSummary: 'HyperSwitch Mechanical Keyboard & AeroMouse',
          price: 249,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        RecentOrderCard(
          date: 'Oct 25, 2026',
          orderNumber: '#LH-99445-F',
          status: 'processing',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAhFk7f_jsJ6A7ZwmzJyPFJFz5iseiOcSXQzxYuIAraRVfWoTh2vR-Ov0htgZZU3bHSe7L8lzPP1IyNyVPF1Kw1VlFlfNa1R-xzvVHluSUP0IHzwShum3WZdcc_cyrHuFwGIw7Mi4PretMCAKy-5q3EnrmOFQ0xdayTybOmuLYZPxgBNHMrHAYy9XU1ThMQ16-mKZUQf4OwG5WWOkWq86vtfOTl44UaRaUgNk13XqWZpqLCJA4B6txj',
          itemSummary: 'Vortex Cooling Pad + Pro Stand',
          price: 129.99,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        RecentOrderCard(
          date: 'Oct 26, 2026',
          orderNumber: '#LH-99501-K',
          status: 'placed',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAz7irFdoW6g2GL46IZcSeVFeHIKTAHrdcz50BIrClNCifyA9DCi_-i6LGLCac8pL2GiKCPhinoVkNvrkHKpxZ2kP0VybuBEgcTi-x1eCT3IGoU9Ouy4FXRWjatKPxdFzcaWjjsarozO6_Lt1J2a886RjDzwb8saxBuunnSFI5l0LE5OPLUVi78wUeIf9XDIBj-spR2wj9YVzNKOf9gow7IlOg8q1v9BffqCJtzSvwimrAbUtHkZmZz',
          itemSummary: '6-Port 240W Desktop Charger',
          price: 89,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.inverseSurface,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.primaryContainer
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.support_agent,
                    color: AppColors.primaryFixedDim, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need help with an order?',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                                color: AppColors.inverseOnSurface)),
                    Text('Our support team is online.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                color: AppColors.inverseOnSurface
                                    .withValues(alpha: 0.8))),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  minimumSize: const Size(0, 40),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text('Chat Now'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
