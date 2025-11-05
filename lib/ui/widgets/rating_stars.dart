import 'package:flutter/material.dart';

import '../theme/colors.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final stars = List.generate(5, (index) {
      final filled = rating >= index + 1;
      final half = rating > index && rating < index + 1;
      return Icon(
        filled
            ? Icons.star
            : half
                ? Icons.star_half
                : Icons.star_border,
        color: AppColors.accent,
        size: 18,
      );
    });
    return Row(
      children: [
        ...stars,
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 4),
        Text('(${reviewCount.toString()})',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).hintColor)),
      ],
    );
  }
}
