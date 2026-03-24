import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/station.dart';

class PlacesService {
  // Try both localhost and 127.0.0.1 for better compatibility
  static const String proxyBase = 'http://localhost:3000';

  Future<List<Station>> findNearbyGasStations({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    debugPrint('PlacesService: Calling proxy for $lat, $lng');

    try {
      final uri = Uri.parse('$proxyBase/nearby').replace(
        queryParameters: {
          'lat': lat.toString(),
          'lng': lng.toString(),
          'radius': radiusMeters.toString(),
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      debugPrint('Proxy response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];

        debugPrint('Proxy returned ${results.length} results');

        return results
            .map((json) => _stationFromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('Proxy error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('PlacesService error: $e');
    }

    return [];
  }

  Station _stationFromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']?['location'] as Map<String, dynamic>?;
    final lat = (geometry?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (geometry?['lng'] as num?)?.toDouble() ?? 0.0;

    return Station(
      id:
          json['place_id'] ??
          json['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Unknown Station',
      position: LatLng(lat, lng),
      address: json['vicinity'] ?? json['formatted_address'] ?? '',
      petrolPrice: 0.0,
      dieselPrice: 0.0,
      fuelType: '95',
      lastUpdated: 'Now',
      province: 'Western Cape',
    );
  }
}
