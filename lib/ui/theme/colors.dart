import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFFFF8A65);
  static const accent = Color(0xFF1DE9B6);
  static const neutral = Color(0xFF1F1F29);
  static const surface = Color(0xFFF7F7FB);

  static const gradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4B47D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
