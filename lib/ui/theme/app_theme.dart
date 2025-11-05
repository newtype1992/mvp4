import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.urbanistTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutral,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      chipTheme: base.chipTheme.copyWith(
        labelStyle: GoogleFonts.urbanist(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: const Color(0xFF0F1018),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.urbanistTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: GoogleFonts.urbanist(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      useMaterial3: true,
    );
  }
}
