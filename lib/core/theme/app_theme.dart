import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final baseText = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: baseText.copyWith(
        // headline-lg-mobile: 24/32 weight 700
        headlineLarge: GoogleFonts.inter(fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w700, letterSpacing: -0.01, color: AppColors.onSurface),
        // headline-md: 24/32 weight 600
        headlineMedium: GoogleFonts.inter(fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        // headline-sm: 20/28 weight 600
        headlineSmall: GoogleFonts.inter(fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        // body-lg / body-md / body-sm
        bodyLarge: GoogleFonts.inter(fontSize: 18, height: 28 / 18, color: AppColors.onSurfaceVariant),
        bodyMedium: GoogleFonts.inter(fontSize: 16, height: 24 / 16, color: AppColors.onSurfaceVariant),
        bodySmall: GoogleFonts.inter(fontSize: 14, height: 20 / 14, color: AppColors.onSurfaceVariant),
        // label-md / label-sm
        labelLarge: GoogleFonts.inter(fontSize: 14, height: 16 / 14, fontWeight: FontWeight.w600, letterSpacing: 0.05, color: AppColors.onPrimary),
        labelSmall: GoogleFonts.inter(fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(56),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: AppColors.outline),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, letterSpacing: 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
