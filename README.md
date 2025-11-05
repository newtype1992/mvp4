# Swift Slots

Swift Slots is a Flutter multi-platform experience that showcases how customers can instantly book discounted last-minute openings from gyms, salons, and clinics nearby. The app ships with mock data, deterministic generators, and a complete user journey from onboarding to confirmation.

## Getting Started

### Prerequisites
- Flutter stable (3.19 or newer) with Dart SDK 3.3+
- Xcode / Android Studio or command-line tools for target platforms

### Setup
```bash
flutter pub get
```

### Run
Web (Chrome):
```bash
flutter run -d chrome
```

iOS (physical or simulator):
```bash
flutter run -d <device_id>
```

Android:
```bash
flutter run -d android
```

### Test Plan Walkthrough
1. Complete onboarding by selecting interests, granting mock location, and opting into notifications.
2. Use the feed filters to narrow results, then switch to the map tab and inspect clustered pins.
3. Open a slot, review business details, and start booking.
4. Apply optional promo code, simulate payment, and observe confirmation with QR code placeholder.
5. Add to calendar (stub), share booking, and explore watchlist/favorites.
6. Toggle Demo Mode to reseed interests and location for rapid demos.
7. Visit the debug panel to spawn cancellations and trigger a notification preview.

### Demo Mode
Use the `Demo Mode` toggle in profile settings to auto-enable interests, watch popular categories, and simulate fresh cancellations for live demos.

## Notes
- All services run in-memory with deterministic seeding.
- Local notifications are simulated via `flutter_local_notifications`; no external keys are required.
- Maps leverage OpenStreetMap via `flutter_map` with mock coordinates in Austin, TX.
