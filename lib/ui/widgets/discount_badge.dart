import 'package:flutter/material.dart';

import '../../core/utils/accessibility.dart';
import '../theme/colors.dart';

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.discountPercent});

  final int discountPercent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: discountSemantics(discountPercent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: AppColors.badgeGradient,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          '-$discountPercent%',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
        ),
      ),
    );
  }
}
