import 'dart:convert';

import 'package:http/http.dart' as http;

class PlaceLite {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? priceLevel; // enum text from API
  final String? firstPhotoName; // e.g., places/XYZ/photos/abc

  const PlaceLite({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.priceLevel,
    this.firstPhotoName,
  });
}

class PlacesService {
  static const String _endpoint = 'https://places.googleapis.com/v1/places:searchNearby';

  final String apiKey;
  final http.Client _client;

  PlacesService({required this.apiKey, http.Client? client}) : _client = client ?? http.Client();

  Future<List<PlaceLite>> searchNearby({
    required double latitude,
    required double longitude,
    int radiusMeters = 1200,
    String rankPreference = 'DISTANCE',
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'places.id,places.displayName,places.location,places.rating,places.priceLevel,places.photos',
    };

    final body = jsonEncode({
      'includedTypes': ['restaurant'],
      'maxResultCount': 20,
      'rankPreference': rankPreference,
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': latitude,
            'longitude': longitude,
          },
          'radius': radiusMeters,
        }
      },
    });

    final resp = await _client.post(Uri.parse(_endpoint), headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Places API error: ${resp.statusCode} ${resp.body}');
    }

    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    final List<dynamic> places = (decoded['places'] as List?) ?? const [];
    return places.map((p) {
      final id = p['id'] as String? ?? '';
      final name = (p['displayName']?['text'] as String?) ?? 'Sin nombre';
      final loc = p['location'] as Map<String, dynamic>?;
      final lat = (loc?['latitude'] as num?)?.toDouble() ?? 0;
      final lng = (loc?['longitude'] as num?)?.toDouble() ?? 0;
      final rating = (p['rating'] as num?)?.toDouble();
      final priceLevel = p['priceLevel'] as String?;
      final photos = (p['photos'] as List?) ?? const [];
      final firstPhotoName = photos.isNotEmpty ? (photos.first['name'] as String?) : null;

      return PlaceLite(
        id: id,
        name: name,
        latitude: lat,
        longitude: lng,
        rating: rating,
        priceLevel: priceLevel,
        firstPhotoName: firstPhotoName,
      );
    }).toList(growable: false);
  }

  String? buildPhotoUrl(String? photoName, {int maxWidthPx = 300, int maxHeightPx = 200}) {
    if (photoName == null) return null;
    // GET https://places.googleapis.com/v1/{photo.name}/media?maxWidthPx=300&maxHeightPx=200&key=<API_KEY>
    final encoded = Uri.encodeComponent(photoName);
    return 'https://places.googleapis.com/v1/$encoded/media?maxWidthPx=$maxWidthPx&maxHeightPx=$maxHeightPx&key=$apiKey';
  }
}


