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

## Tailwind CSS landing page
Swift Slots now ships with a Tailwind-powered marketing landing page for quick web previews of the product story.

### Setup
- The landing page lives in `web/index.html` and uses the [Tailwind CSS CDN build](https://cdn.tailwindcss.com) for zero-config bundling.
- Custom theme tokens (colors, shadows, and font stacks) are declared via the in-page `tailwind.config` override so Flutter builds can reuse the same HTML shell.
- Google Fonts (`Poppins` for display, `Inter` for supporting copy) are preloaded for typographic consistency.

To view the landing experience locally run a Flutter web build (or serve the HTML directly):

```bash
flutter run -d chrome
# or
python -m http.server --directory web 8080
```

### Color palette
The Tailwind configuration exposes the following brand palette inspired by the design references:

| Token      | Hex     | Usage                                      |
|------------|---------|---------------------------------------------|
| `primary`  | `#FF6B6B` | Primary actions, gradient starting hue       |
| `secondary`| `#FF9472` | Gradient blend, highlight surfaces           |
| `accent`   | `#22D3EE` | Informational pills, accent buttons          |
| `success`  | `#22C55E` | Live indicators and discount badges          |
| `warning`  | `#F59E0B` | Ratings, emphasis strokes                   |
| `neutral`  | `#1E293B` (900) | Primary text, structural contrast           |
| `background` | `#F6F8FC` | Page background, subtle contrast backdrop    |
| `surface`  | `#FFFFFF` | Card backgrounds, elevated containers        |

### Accessibility and responsiveness
- Utility classes apply high-contrast text (`text-neutral-900`) on light surfaces and ensure gradient sections include white overlays for readability.
- Interactive controls use `focus-visible` rings to ensure keyboard users receive visible cues.
- Layouts switch between stacked and multi-column grids via Tailwind responsive breakpoints, keeping the page legible on mobile, tablet, and desktop.
