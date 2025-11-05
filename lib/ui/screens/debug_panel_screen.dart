import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_state.dart';

class DebugPanelScreen extends ConsumerWidget {
  const DebugPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(slotStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Debug panel')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Demo controls',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.add_alert),
              label: const Text('Trigger notification preview'),
              onPressed: () => ref.read(notificationServiceProvider).showSampleNotification(),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.schedule_send),
              label: const Text('Spawn new cancellation'),
              onPressed: () => ref.read(mockDataServiceProvider).triggerDemoDrop(),
            ),
            const SizedBox(height: 24),
            Text('Live slot count', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            slotsAsync.when(
              data: (slots) => Text('${slots.length} active opportunities'),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),
            const Text('Deep link sample:'),
            SelectableText('swiftslots://slot/DEMO123'),
          ],
        ),
      ),
    );
  }
}
