import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.cta500,
      onPrimary: Colors.white,
      secondary: AppColors.highlight500,
      onSecondary: AppColors.neutral900,
      error: Colors.red.shade600,
      onError: Colors.white,
      background: AppColors.neutral025,
      onBackground: AppColors.neutral900,
      surface: Colors.white,
      onSurface: AppColors.neutral900,
      tertiary: AppColors.supportPink,
      onTertiary: Colors.white,
      surfaceVariant: AppColors.neutral050,
      onSurfaceVariant: AppColors.neutral600,
      outline: AppColors.neutral200,
      shadow: const Color(0x1A0B1020),
      scrim: const Color(0x330B1020),
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.neutral025,
      textTheme: GoogleFonts.urbanistTextTheme(base.textTheme).apply(
        bodyColor: AppColors.neutral900,
        displayColor: AppColors.neutral900,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutral025,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral900,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cta500,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.highlight500,
          side: const BorderSide(color: AppColors.highlight200),
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neutral100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cta500, width: 1.4),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.cta500,
      onPrimary: Colors.white,
      secondary: AppColors.highlight500,
      onSecondary: AppColors.neutral900,
      error: Colors.red.shade200,
      onError: Colors.black,
      background: AppColors.neutral900,
      onBackground: AppColors.neutral025,
      surface: AppColors.neutral800,
      onSurface: Colors.white,
      tertiary: AppColors.supportPink,
      onTertiary: Colors.white,
      surfaceVariant: const Color(0xFF232A3C),
      onSurfaceVariant: Colors.white70,
      outline: const Color(0xFF3E4659),
      shadow: Colors.black45,
      scrim: Colors.black54,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.neutral900,
      textTheme: GoogleFonts.urbanistTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutral900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.neutral800,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cta400,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.highlight400,
          side: BorderSide(color: AppColors.highlight400.withOpacity(0.4)),
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF3E4659)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.cta500, width: 1.4),
        ),
      ),
      useMaterial3: true,
    );
  }
}
