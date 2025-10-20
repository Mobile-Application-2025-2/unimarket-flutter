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

The app now includes nearby restaurants functionality using Google Places API v1:

- Automatically loads nearby restaurants when the map centers on user location
- Shows markers for restaurants with tap interactions
- Bottom sheet displays restaurant details (photo, name, rating, price level)
- "Cómo llegar" button opens Google Maps for directions

Features:
- Radius: 1200m (configurable)
- Rank preference: DISTANCE (configurable)
- Photo support via Places Photos API
- Error handling for API failures

Permissions:
- Location permission is required (already configured in project)