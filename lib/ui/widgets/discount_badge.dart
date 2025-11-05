import 'package:flutter/material.dart';

import '../../core/utils/accessibility.dart';

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.discountPercent});

  final int discountPercent;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: discountSemantics(discountPercent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Text(
          '-$discountPercent%',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
