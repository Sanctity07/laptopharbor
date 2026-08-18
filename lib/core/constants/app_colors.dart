import 'package:flutter/material.dart';

/// Palette sourced from the Stitch design tokens (Material 3 roles).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00685F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF008378);
  static const Color onPrimaryContainer = Color(0xFFF4FFFC);
  static const Color primaryFixed = Color(0xFF89F5E7);
  static const Color primaryFixedDim = Color(0xFF6BD8CB);

  static const Color secondary = Color(0xFF545F73);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD5E0F8);
  static const Color onSecondaryContainer = Color(0xFF586377);

  static const Color tertiary = Color(0xFF006387);
  static const Color tertiaryContainer = Color(0xFF007DA9);
  static const Color onTertiaryContainer = Color(0xFFFCFCFF);
  static const Color tertiaryFixed = Color(0xFFC4E7FF);

  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCCDBF2);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEEF4FF);
  static const Color surfaceContainer = Color(0xFFE5EFFF);
  static const Color surfaceContainerHigh = Color(0xFFDBE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD4E4FA);
  static const Color surfaceVariant = Color(0xFFD4E4FA);

  static const Color onBackground = Color(0xFF0D1C2D);
  static const Color onSurface = Color(0xFF0D1C2D);
  static const Color onSurfaceVariant = Color(0xFF3D4947);

  static const Color outline = Color(0xFF6D7A77);
  static const Color outlineVariant = Color(0xFFBCC9C6);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);

  // Convenience aliases used across existing widgets/screens.
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color border = outlineVariant;
  static const Color accent = primaryContainer;

  // Inverse surface roles — dark card / snackbar style elements.
  static const Color inverseSurface = Color(0xFF0D1C2D);       // = onSurface
  static const Color inverseOnSurface = Color(0xFFEEF4FF);     // = surfaceContainerLow
}
