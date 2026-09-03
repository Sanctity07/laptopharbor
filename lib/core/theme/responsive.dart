import 'package:flutter/material.dart';

/// Breakpoints matching the Stitch design system.
class Breakpoints {
  Breakpoints._();

  static const double compact = 600;  // phone → tablet boundary
  static const double medium = 900;   // tablet → desktop boundary
  static const double expanded = 1200; // wide desktop
}

/// Returns the horizontal page padding based on screen width.
/// Narrow: 16 • Tablet: 32 • Desktop: 48 • Wide: auto-centred via maxWidth.
double responsiveHPadding(double width) {
  if (width >= Breakpoints.expanded) return 48;
  if (width >= Breakpoints.medium) return 32;
  if (width >= Breakpoints.compact) return 24;
  return 16;
}

/// Wraps [child] in a centred, max-width constrained container.
/// Use on every page body so content never stretches past [maxWidth] pixels.
class PageBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool addHorizontalPadding;

  const PageBody({
    super.key,
    required this.child,
    this.maxWidth = 1280,
    this.addHorizontalPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final hPad = addHorizontalPadding ? responsiveHPadding(w) : 0.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: child,
        ),
      ),
    );
  }
}

/// Sliver-compatible page padding that responds to screen width.
EdgeInsets responsivePagePadding(double width) {
  final h = responsiveHPadding(width);
  return EdgeInsets.fromLTRB(h, 16, h, 32);
}
