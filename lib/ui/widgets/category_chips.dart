import 'package:flutter/material.dart';

import '../../core/models/category.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onToggle,
  });

  final List<Category> categories;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final category in categories)
          FilterChip(
            label: Text('${category.emoji} ${category.name}'),
            selected: selected.contains(category.id),
            onSelected: (_) => onToggle(category.id),
            showCheckmark: false,
          ),
      ],
    );
  }
}
