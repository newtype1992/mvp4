import 'package:flutter/material.dart';

class Category {
  Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.primaryColor,
  });

  final String id;
  final String name;
  final String emoji;
  final Color primaryColor;
}
