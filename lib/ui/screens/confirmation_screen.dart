import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/colors.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.slotId});

  final String slotId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.cta050,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 64, color: AppColors.cta500),
              ),
              const SizedBox(height: 24),
              Text(
                'You're booked!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The business has been notified and will be ready when you arrive.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () => context.go('/'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Browse more slots'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
