import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const cta500 = Color(0xFF00BFA6);
  static const cta400 = Color(0xFF20D5BA);
  static const cta050 = Color(0xFFE4FFFA);

  static const highlight500 = Color(0xFF4CC9F0);
  static const highlight400 = Color(0xFF6DD4F4);
  static const highlight200 = Color(0xFFB3EAFB);
  static const highlight050 = Color(0xFFF0FBFF);

  static const supportYellow = Color(0xFFFFBE0B);
  static const supportPink = Color(0xFFF15BB5);

  static const neutral900 = Color(0xFF0B1020);
  static const neutral800 = Color(0xFF1C2236);
  static const neutral700 = Color(0xFF2C3447);
  static const neutral600 = Color(0xFF3E475C);
  static const neutral500 = Color(0xFF505A70);
  static const neutral400 = Color(0xFF7C869D);
  static const neutral300 = Color(0xFFA6AFC3);
  static const neutral200 = Color(0xFFCDD3DF);
  static const neutral100 = Color(0xFFE6EAF2);
  static const neutral050 = Color(0xFFF0F3F8);
  static const neutral025 = Color(0xFFF5F7FA);

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFF5F7FA), Color(0xFFEFF9FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
