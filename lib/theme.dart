import 'package:flutter/material.dart';

/// Color palette aligned with the Svelte web version of Manilakbay.
/// The map uses a light CartoDB tile — UI chrome is light/white with
/// amber/gold brand accents.
class AppColors {
  // Brand
  static const Color amber = Color(0xFFF59E0B);       // jeepney, brand accent
  static const Color amberDark = Color(0xFFB45309);

  // Transport route colors (matches Svelte TRANSPORT_COLORS)
  static const Color jeepneyColor  = Color(0xFFF59E0B); // amber
  static const Color busColor      = Color(0xFFEF4444); // red
  static const Color uvColor       = Color(0xFF8B5CF6); // purple
  static const Color tricycleColor = Color(0xFF10B981); // emerald
  static const Color bicycleColor  = Color(0xFF3B82F6); // blue

  // Sidewalk colors (matches Svelte SIDEWALK_COLOR_MAP)
  static const Color swWide       = Color(0xFF22C55E); // green  ≥5m
  static const Color swModerate   = Color(0xFFEAB308); // yellow 3–5m
  static const Color swNarrow     = Color(0xFFF97316); // orange 1.2–3m
  static const Color swVeryNarrow = Color(0xFFEF4444); // red    <1.2m
  static const Color swImpassable = Color(0xFF171717); // near-black

  // UI surface (light)
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color surfaceAlpha = Color(0xF2FFFFFF); // ~95% white
  static const Color border       = Color(0x1A000000); // 10% black
  static const Color divider      = Color(0x14000000); // 8% black

  // Text
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textMuted     = Color(0xFF9CA3AF);
  static const Color textLabel     = Color(0xFF6B7280);

  // Zoom badge states
  static const Color zoomLockedBg   = Color(0xFFFFFBEB); // amber tint
  static const Color zoomUnlockedBg = Color(0xFFF0FDF4); // green tint
  static const Color zoomLockedText  = Color(0xFF92400E);
  static const Color zoomUnlockedText = Color(0xFF166534);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.amber,
          secondary: AppColors.bicycleColor,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: const Color(0xFFE8E8E8),
        fontFamily: 'Roboto',
      );
}
