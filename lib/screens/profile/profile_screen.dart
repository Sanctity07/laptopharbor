import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/login_screen.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/settings_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

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
                // Profile header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 4),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: const ClipOval(
                              child: ColoredBox(
                                color: AppColors.primaryContainer,
                                child: Icon(Icons.person, size: 56, color: AppColors.onPrimaryContainer),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.edit, size: 16, color: AppColors.onPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text('Alex Thompson', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 16, color: AppColors.onSurface),
                            const SizedBox(width: 4),
                            Text('Pro Member', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Stats row
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.stackMd,
                  crossAxisSpacing: AppSpacing.stackMd,
                  childAspectRatio: 0.9,
                  children: const [
                    ProfileStatCard(value: '12', label: 'Orders'),
                    ProfileStatCard(value: '4', label: 'Reviews'),
                    ProfileStatCard(value: '28', label: 'Saved'),
                    ProfileStatCard(value: '2k', label: 'Points'),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Account settings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'ACCOUNT SETTINGS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline, letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                  ),
                  child: Column(
                    children: [
                      SettingsListTile(icon: Icons.manage_accounts_outlined, label: 'Edit Profile', onTap: () {}),
                      const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.outlineVariant),
                      SettingsListTile(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () {}),
                      const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.outlineVariant),
                      SettingsListTile(icon: Icons.lock_outline, label: 'Password', onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                  ),
                  child: SettingsListTile(
                    icon: Icons.logout,
                    label: 'Logout',
                    isDestructive: true,
                    onTap: () => _logout(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),

                // Support card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.stackMd),
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
                            Text(
                              'Need assistance?',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.onTertiaryContainer),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Our technical support team is available 24/7 for Pro Members.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onTertiaryContainer.withValues(alpha: 0.9)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.onTertiaryContainer, shape: BoxShape.circle),
                        child: Icon(Icons.support_agent, color: AppColors.tertiaryContainer),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),

                Center(
                  child: Text(
                    'LaptopHarbor v1.0.4 • Built with Precision',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLg),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}