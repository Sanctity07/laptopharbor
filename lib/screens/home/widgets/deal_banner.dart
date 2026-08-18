import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class DealBanner extends StatelessWidget {
  final String imageUrl;
  final String tag;
  final String title;
  final String description;
  final VoidCallback onShopNow;

  const DealBanner({
    super.key,
    required this.imageUrl,
    required this.tag,
    required this.title,
    required this.description,
    required this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Keep a 16:9 feel but enforce a minimum height so content never clips.
          final bannerHeight = (constraints.maxWidth * 9 / 16).clamp(180.0, 340.0);
          final isNarrow = constraints.maxWidth < 360;

          return SizedBox(
            height: bannerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.onSurface.withValues(alpha: 0.70),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isNarrow ? 12.0 : AppSpacing.stackMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tag badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onPrimaryContainer,
                              ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title — scales down on narrow screens
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: (isNarrow
                                  ? Theme.of(context).textTheme.headlineSmall
                                  : Theme.of(context).textTheme.headlineLarge)
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Description — hidden on very narrow banners to save space
                      if (!isNarrow)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 240),
                          child: Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: onShopNow,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 38),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Shop Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}