import 'package:flutter/material.dart';

/// LaptopHarbor 2.0 — Premium dark-navy + electric-indigo palette.
/// Inspired by high-end tech storefronts (Apple, Vercel, Linear).
class AppColors {
  AppColors._();

  // ── Brand primaries ────────────────────────────────────────────────────
  /// Electric indigo — CTA buttons, links, active states
  static const Color primary = Color(0xFF6366F1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEEF2FF);
  static const Color onPrimaryContainer = Color(0xFF3730A3);

  /// Soft indigo dim — used on dark nav backgrounds
  static const Color primaryFixed = Color(0xFFC7D2FE);
  static const Color primaryFixedDim = Color(0xFFA5B4FC);

  // ── Secondary (slate) ──────────────────────────────────────────────────
  static const Color secondary = Color(0xFF64748B);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF1F5F9);
  static const Color onSecondaryContainer = Color(0xFF334155);

  // ── Tertiary (violet accent) ───────────────────────────────────────────
  static const Color tertiary = Color(0xFF7C3AED);
  static const Color tertiaryContainer = Color(0xFF8B5CF6);
  static const Color onTertiaryContainer = Color(0xFFFFFFFF);
  static const Color tertiaryFixed = Color(0xFFEDE9FE);

  // ── Backgrounds & surfaces ─────────────────────────────────────────────
  /// Page background — near-white with a cool tint
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFE2E8F0);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFCBD5E1);
  static const Color surfaceVariant = Color(0xFFE2E8F0);

  // ── On-surface text ────────────────────────────────────────────────────
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurface = Color(0xFF0F172A);        // slate-900
  static const Color onSurfaceVariant = Color(0xFF475569); // slate-600

  // ── Borders ────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF94A3B8);          // slate-400
  static const Color outlineVariant = Color(0xFFE2E8F0);   // slate-200

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  static const Color success = Color(0xFF10B981);     // emerald-500
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);     // amber-500
  static const Color warningContainer = Color(0xFFFEF3C7);

  // ── Convenience aliases ────────────────────────────────────────────────
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color border = outlineVariant;
  static const Color accent = primary;

  // ── Dark nav rail / drawer ─────────────────────────────────────────────
  /// Deep navy used as the app-bar / nav background
  static const Color navBackground = Color(0xFF0F172A);    // slate-900
  static const Color navForeground = Color(0xFFF1F5F9);    // slate-100
  static const Color navIndicator = Color(0xFF1E3A5F);     // navy highlight

  // ── Inverse (snackbar, dark cards) ────────────────────────────────────
  static const Color inverseSurface = Color(0xFF1E293B);   // slate-800
  static const Color inverseOnSurface = Color(0xFFF1F5F9); // slate-100

  // ── Gradient helpers ───────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
