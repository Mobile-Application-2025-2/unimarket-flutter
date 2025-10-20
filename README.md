# Unimarket - Flutter group 43

| Nombre|  |
|---|---|
|Daniel Felipe Ortiz| df.ortizv1 |
| Julian Rolon | j.rolont |
| Javier Barrera | js.barrerat1 |

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Nearby Restaurants (Google Places v1)

Setup API key:

- Create a restricted API key for Google Places API (Places API (New), Places API, Maps SDKs as needed). Restrict to your app package/bundle and specific APIs.
- Do not hardcode the key. Pass it via dart-define:

```bash
flutter run --dart-define=PLACES_API_KEY=YOUR_KEY
```

Android/iOS:

- Android: You may also provide the key via `local.properties`/build config if desired, but Flutter code reads it from `--dart-define`.
- iOS: Keep restrictions in the Cloud Console and Info.plist as needed; Flutter code reads from `--dart-define`.

Permissions:

- Location permission is required. Make sure your AndroidManifest and iOS Info.plist contain location usage descriptions (already configured in project).

Testing params:

- Radius: 600 / 1200 / 2000 (configured in call site).
- Rank preference: DISTANCE or POPULARITY.
