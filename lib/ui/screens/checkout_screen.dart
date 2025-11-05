import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/formatters.dart';
import '../../state/app_state.dart';
import '../widgets/app_form_field.dart';
import '../widgets/primary_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String name = 'Taylor Morgan';
  String email = 'taylor@swiftslots.demo';
  String promoCode = '';

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);
    final slot = checkoutState.activeSlot;
    final businesses = ref.watch(businessesProvider);
    if (slot == null) {
      return const Scaffold(
        body: Center(child: Text('Select a slot to book.')),
      );
    }
    final business = businesses.firstWhere((biz) => biz.id == slot.businessId);
    final total = slot.discountedPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm & pay')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(business.name, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text('${formatTimeRange(slot.startsAt, slot.endsAt)} · ${business.address}'),
              trailing: Chip(label: Text('-${slot.discountPercent}%')),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guest info',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    AppFormField(
                      label: 'Full name',
                      initialValue: name,
                      onChanged: (value) => setState(() => name = value),
                    ),
                    const SizedBox(height: 12),
                    AppFormField(
                      label: 'Email',
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() => email = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment method',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined),
                          const SizedBox(width: 12),
                          const Text('Apple Pay · **** 4242'),
                          const Spacer(),
                          TextButton(onPressed: () {}, child: const Text('Change')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppFormField(
                      label: 'Promo code',
                      initialValue: promoCode,
                      onChanged: (value) => setState(() => promoCode = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _PriceRow(label: 'Subtotal', value: formatCurrency(slot.originalPrice)),
                    _PriceRow(label: 'Swift Slots discount', value: '-${formatCurrency(slot.originalPrice - total)}'),
                    _PriceRow(label: 'Service fee', value: formatCurrency(total * 0.05)),
                    const Divider(),
                    _PriceRow(
                      label: 'Total due today',
                      value: formatCurrency(total * 1.05),
                      emphasize: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: checkoutState.isProcessing ? 'Processing' : 'Pay with Apple Pay',
              icon: Icons.phone_iphone,
              loading: checkoutState.isProcessing,
              onPressed: checkoutState.isProcessing
                  ? null
                  : () async {
                      ref.read(checkoutProvider.notifier).setProcessing(true);
                      await ref.read(payServiceProvider).simulatePayment(amount: total);
                      ref.read(checkoutProvider.notifier).markSuccess();
                      if (mounted) {
                        context.go('/confirmation');
                      }
                    },
            ),
            const SizedBox(height: 12),
            Text(
              'By tapping pay you agree to the Swift Slots Terms and Privacy Policy.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}
