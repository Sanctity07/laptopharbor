import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../orders/order_history_screen.dart';

/// Side navigation drawer matching the Stitch `#nav-drawer` — profile
/// header, primary nav links, settings, footer version/copyright.
class ProNavDrawer extends StatelessWidget {
  const ProNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(Icons.person, color: AppColors.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tech Enthusiast', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
                      Text('Pro Member', style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: 24),
              _NavItem(icon: Icons.laptop_mac, label: 'Laptops', selected: true, onTap: () => Navigator.of(context).pop()),
              _NavItem(icon: Icons.mouse, label: 'Accessories', onTap: () => Navigator.of(context).pop()),
              _NavItem(icon: Icons.support_agent, label: 'Support', onTap: () => Navigator.of(context).pop()),
              _NavItem(
  icon: Icons.inventory_2_outlined,
  label: 'My Orders',
  onTap: () {
    Navigator.of(context).pop(); // close the drawer
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
    );
  },
),
              const Divider(height: 32, color: AppColors.outlineVariant),
              _NavItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => Navigator.of(context).pop()),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('v1.0.4', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
                  Text('© 2026 LaptopHarbor', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer.withValues(alpha: 0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}