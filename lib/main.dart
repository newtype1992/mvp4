import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'state/slot_providers.dart';
import 'ui/screens/confirm_booking_screen.dart';
import 'ui/screens/confirmation_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/slot_detail_screen.dart';
import 'ui/theme/app_theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'slot/:slotId',
            builder: (context, state) {
              final slotId = state.pathParameters['slotId']!;
              return SlotDetailScreen(slotId: slotId);
            },
            routes: [
              GoRoute(
                path: 'confirm',
                builder: (context, state) {
                  final slotId = state.pathParameters['slotId']!;
                  return ConfirmBookingScreen(slotId: slotId);
                },
              ),
              GoRoute(
                path: 'confirmation',
                builder: (context, state) {
                  final slotId = state.pathParameters['slotId']!;
                  return ConfirmationScreen(slotId: slotId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SwiftSlotsApp()));
}

class SwiftSlotsApp extends ConsumerWidget {
  const SwiftSlotsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Swift Slots',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
