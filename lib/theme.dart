import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color navyBlue = Color(0xFF0A2463);
  static const Color royalBlue = Color(0xFF1E50A0);
  static const Color skyBlue = Color(0xFF4A90D9);
  static const Color lightYellow = Color(0xFFFFF3B0);
  static const Color gold = Color(0xFFD4A017);
  static const Color brightGold = Color(0xFFFFCC00);
  static const Color warmCream = Color(0xFFFFFBF0);

  // Backgrounds
  static const Color background = Color(0xFF0D1B3E);
  static const Color surface = Color(0xFF162447);
  static const Color cardSurface = Color(0xFF1E3461);

  // Route colors
  static const Color jeepneyColor = Color(0xFFFFCC00); // gold
  static const Color busColor = Color(0xFF4A90D9);     // sky blue
  static const Color tricycleColor = Color(0xFFFF8C42); // orange accent
  static const Color uvExpressColor = Color(0xFF7FD1AE); // teal-green

  // Text
  static const Color textPrimary = Color(0xFFFFFBF0);
  static const Color textSecondary = Color(0xFFB8C9E8);
  static const Color textMuted = Color(0xFF6B85A8);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.royalBlue,
          secondary: AppColors.gold,
          surface: AppColors.surface,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.navyBlue,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navyBlue,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      );
}
