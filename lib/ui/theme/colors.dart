import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF6658F6);
  static const secondary = Color(0xFFFF5A8A);
  static const accent = Color(0xFFFFC15E);
  static const neutral = Color(0xFF12172B);
  static const surface = Color(0xFFF9F7FF);

  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFFF9F7FF), Color(0xFFFFF1F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const appBarGradient = LinearGradient(
    colors: [Color(0xFF6F61FF), Color(0xFFFF6A9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0ECFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [Color(0xFF6F61FF), Color(0xFFFF6A9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const chipGradient = LinearGradient(
    colors: [Color(0xFF7C6BFF), Color(0xFFFF6AA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const badgeGradient = LinearGradient(
    colors: [Color(0xFF6658F6), Color(0xFFFF5A8A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const ctaGradient = LinearGradient(
    colors: [Color(0xFF6F61FF), Color(0xFFFF6A9A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
