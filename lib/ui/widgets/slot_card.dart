import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/models/business.dart';
import '../../core/models/slot.dart';
import '../../core/utils/formatters.dart';
import '../theme/colors.dart';
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
    return Semantics(
      button: true,
      label: 'Slot at ${business.name} discounted ${slot.discountPercent} percent',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: business.heroImage,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: DiscountBadge(discountPercent: slot.discountPercent),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.28),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: onWatchToggle,
                          icon: Icon(
                            isWatched ? Icons.visibility : Icons.visibility_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          formatDistance(business.distanceMiles),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      business.tagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral.withOpacity(0.72),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        TimeChip(duration: slot.startsIn),
                        const SizedBox(width: 12),
                        Text(
                          formatTimeRange(slot.startsAt, slot.endsAt),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            formatCurrency(slot.discountedPrice),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                            ),
                          ),
                        ),
                        RatingStars(rating: business.rating, reviewCount: business.reviewCount),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Originally ${formatCurrency(slot.originalPrice)} · ${slot.seatsRemaining} spot(s) left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
