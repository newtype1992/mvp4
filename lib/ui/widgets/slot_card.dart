import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import 'discount_badge.dart';
import 'rating_stars.dart';
import 'time_chip.dart';

class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slot,
    required this.business,
    required this.onTap,
    required this.onWatchToggle,
    required this.isWatched,
  });

  final Slot slot;
  final Business business;
  final VoidCallback onTap;
  final VoidCallback onWatchToggle;
  final bool isWatched;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: 'Slot at ${business.name} discounted ${slot.discountPercent} percent',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: business.heroImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: DiscountBadge(discountPercent: slot.discountPercent),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton.filledTonal(
                        onPressed: onWatchToggle,
                        icon: Icon(isWatched ? Icons.visibility : Icons.visibility_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business.tagline,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TimeChip(duration: slot.startsIn),
                        const SizedBox(width: 12),
                        Text(
                          formatTimeRange(slot.startsAt, slot.endsAt),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatCurrency(slot.discountedPrice)} • ${formatDistance(business.distanceMiles)}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        RatingStars(rating: business.rating, reviewCount: business.reviewCount),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Originally ${formatCurrency(slot.originalPrice)} · ${slot.seatsRemaining} spot(s) left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
