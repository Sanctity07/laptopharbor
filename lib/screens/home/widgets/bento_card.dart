import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BentoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Widget? action;
  final Alignment contentAlignment;

  const BentoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.action,
    this.contentAlignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            DecoratedBox(decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.25))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: contentAlignment == Alignment.centerLeft
                    ? Alignment.centerLeft
                    : Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ),
                    if (action != null) ...[
                      const SizedBox(height: 10),
                      action!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}