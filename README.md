# Swift Slots MVP

Swift Slots is a cross-platform Flutter demo that lets people discover and claim last-minute discounted appointments from nearby service businesses. The project focuses on showcasing the core marketplace loop so product, sales, and research teams can validate the concept quickly.

## Core Experience
- **Feed of openings:** The home screen lists real-time eligible slots with business name, service, discount, time, and distance.
- **Slot details:** Tapping a card reveals richer business context, pricing, and a prominent “Book now” action.
- **Lightweight booking flow:** A confirmation screen summarizes the reservation before routing to a success state.
- **Demo mode:** A toggle on the feed swaps the seeded data for freshly generated slots to simulate an always-on marketplace. Saved slots persist while you explore.

## Project Structure
```
lib/
  core/
    data/mock_data.dart      # Seeded businesses and slots plus demo generators
    models/                  # Business & Slot value types (Equatable)
    services/slot_service.dart
  state/slot_providers.dart  # Riverpod providers + controllers for feed & saved slots
  ui/
    screens/                 # Home, Slot Detail, Confirm Booking, Confirmation
    theme/                   # Tailwind-inspired theme built on the product palette
```

The app uses `flutter_riverpod` for simple state management, `go_router` for navigation, and Material 3 theming tuned to the Swift Slots palette:

- CTA: `#00BFA6`
- Highlight: `#4CC9F0`
- Support: `#FFBE0B`, `#F15BB5`
- Neutrals: `#0B1020`, `#F5F7FA`

## Getting Started
1. Install [Flutter 3.19+](https://docs.flutter.dev/get-started/install) with the accompanying Dart SDK.
2. Fetch packages:
   ```bash
   flutter pub get
   ```
3. Run on your preferred platform:
   ```bash
   flutter run -d chrome       # Web
   flutter run -d ios          # iOS
   flutter run -d android      # Android
   ```

## Demo Walkthrough
1. Launch the app to browse seeded openings from gyms, salons, physiotherapists, and dentists in Austin, TX.
2. Toggle **Demo mode** to reshuffle the marketplace feed with randomly generated slots that respect each business’s category.
3. Save interesting offers with the bookmark icon, then tap any card to inspect the full details.
4. Continue to **Confirm booking** to review the date, time, duration, and pricing before finalizing.
5. Finish on the confirmation screen and jump back to the feed to keep exploring.

## Landing Page Preview
The repository still includes a zero-dependency Tailwind CDN demo under `web/` that mirrors the in-app palette for marketing previews. Serve it locally with:
```bash
python3 -m http.server --directory web 4173
```
Then open [http://localhost:4173](http://localhost:4173) in your browser.
