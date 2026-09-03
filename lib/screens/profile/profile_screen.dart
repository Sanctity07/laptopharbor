import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/responsive.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../auth/login_screen.dart';
import '../orders/order_history_screen.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/settings_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    context.read<CartProvider>().items.clear();
    context.read<WishlistProvider>().productIds.clear();
    context.read<OrderProvider>().orders.clear();
    await auth.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final orders = context.watch<OrderProvider>().orders;
    final wishlistCount = context.watch<WishlistProvider>().productIds.length;
    final displayName = (user?.name.isNotEmpty == true) ? user!.name : 'Guest';
    final initials = displayName.trim().split(' ').take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.secondary,
            elevation: 0,
            automaticallyImplyLeading: false,
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
            builder: (context, sliverConstraints) {
              final w = sliverConstraints.crossAxisExtent;
              final hPad = responsiveHPadding(w);
              final isWide = w >= Breakpoints.medium;

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 960),
                        child: isWide
                            ? _wideLayout(context, displayName, initials, user,
                                orders.length, wishlistCount)
                            : _narrowLayout(context, displayName, initials, user,
                                orders.length, wishlistCount),
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

  // ── Wide: avatar + info left, settings right ────────────────────────────
  Widget _wideLayout(
    BuildContext context,
    String displayName,
    String initials,
    dynamic user,
    int orderCount,
    int wishlistCount,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column — avatar, name, stats
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _avatarSection(context, displayName, initials, user),
              const SizedBox(height: 24),
              _statsGrid(context, orderCount, wishlistCount, cols: 2),
              const SizedBox(height: 24),
              _supportCard(context),
              const SizedBox(height: 24),
              _versionLabel(context),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right column — settings list
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _settingsSection(context),
              const SizedBox(height: 24),
              _logoutSection(context),
            ],
          ),
        ),
      ],
    );
  }

  // ── Narrow: stacked single column ────────────────────────────────────────
  Widget _narrowLayout(
    BuildContext context,
    String displayName,
    String initials,
    dynamic user,
    int orderCount,
    int wishlistCount,
  ) {
    return Column(
      children: [
        _avatarSection(context, displayName, initials, user),
        const SizedBox(height: 24),
        _statsGrid(context, orderCount, wishlistCount, cols: 4),
        const SizedBox(height: 24),
        _settingsSection(context),
        const SizedBox(height: 24),
        _logoutSection(context),
        const SizedBox(height: 24),
        _supportCard(context),
        const SizedBox(height: 24),
        _versionLabel(context),
      ],
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────

  Widget _avatarSection(
      BuildContext context, String displayName, String initials, dynamic user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 4),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: ClipOval(
                child: user?.photoUrl != null
                    ? Image.network(user!.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(initials))
                    : _avatarFallback(initials),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child:
                      const Icon(Icons.edit, size: 16, color: AppColors.onPrimary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(displayName,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
        if (user?.email?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(user!.email,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.onSurface),
              const SizedBox(width: 4),
              Text('Pro Member',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsGrid(BuildContext context, int orderCount, int wishlistCount,
      {required int cols}) {
    final cards = [
      ProfileStatCard(value: orderCount.toString(), label: 'Orders'),
      const ProfileStatCard(value: '4', label: 'Reviews'),
      ProfileStatCard(value: wishlistCount.toString(), label: 'Saved'),
      const ProfileStatCard(value: '2k', label: 'Points'),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: cols == 2 ? 1.4 : 0.9,
      children: cards,
    );
  }

  Widget _settingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            'ACCOUNT SETTINGS',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.outline, letterSpacing: 1.5),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
            ],
          ),
          child: Column(
            children: [
              SettingsListTile(
                  icon: Icons.manage_accounts_outlined,
                  label: 'Edit Profile',
                  onTap: () {}),
              const Divider(
                  height: 1, indent: 16, endIndent: 16, color: AppColors.outlineVariant),
              SettingsListTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'Order History',
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const OrderHistoryScreen()),
                      )),
              const Divider(
                  height: 1, indent: 16, endIndent: 16, color: AppColors.outlineVariant),
              SettingsListTile(
                  icon: Icons.location_on_outlined,
                  label: 'Saved Addresses',
                  onTap: () {}),
              const Divider(
                  height: 1, indent: 16, endIndent: 16, color: AppColors.outlineVariant),
              SettingsListTile(
                  icon: Icons.lock_outline, label: 'Password', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logoutSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: SettingsListTile(
        icon: Icons.logout,
        label: 'Logout',
        isDestructive: true,
        onTap: () => _logout(context),
      ),
    );
  }

  Widget _supportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need assistance?',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppColors.onTertiaryContainer)),
                const SizedBox(height: 4),
                Text(
                  'Our technical support team is available 24/7 for Pro Members.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                          color: AppColors.onTertiaryContainer
                              .withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.onTertiaryContainer, shape: BoxShape.circle),
            child: Icon(Icons.support_agent, color: AppColors.tertiaryContainer),
          ),
        ],
      ),
    );
  }

  Widget _versionLabel(BuildContext context) {
    return Text(
      'LaptopHarbor v1.0.4 • Built with Precision',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
    );
  }

  Widget _avatarFallback(String initials) {
    return ColoredBox(
      color: AppColors.primaryContainer,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
