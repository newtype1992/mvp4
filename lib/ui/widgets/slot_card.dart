import 'package:flutter/material.dart';

import '../../state/slot_providers.dart';
import '../theme/colors.dart';

class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.data,
    required this.isSaved,
    required this.onSaveTap,
    required this.onTap,
  });

  final SlotPresentation data;
  final bool isSaved;
  final VoidCallback onSaveTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0B1020),
              blurRadius: 18,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(imageUrl: data.business.heroImage, discount: data.discountLabel),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.business.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.slot.service,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.neutral600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onSaveTap,
                        icon: Icon(
                          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isSaved ? AppColors.highlight400 : AppColors.neutral400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoPill(
                        icon: Icons.schedule_rounded,
                        label: data.timeLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        data.priceLabel,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.cta500,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        data.originalPriceLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.neutral400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      _InfoPill(
                        icon: Icons.place_outlined,
                        label: '${data.business.distanceMiles.toStringAsFixed(1)} mi',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.imageUrl,
    required this.discount,
  });

  final String imageUrl;
  final String discount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.supportPink,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                discount,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neutral050,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.highlight400),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.neutral600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
