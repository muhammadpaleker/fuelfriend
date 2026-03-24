import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  final String id;
  final String name;
  final LatLng position;
  final double petrolPrice;
  final double dieselPrice;
  final String fuelType;
  final String lastUpdated;
  final String address;
  final String province;

  const Station({
    required this.id,
    required this.name,
    required this.position,
    required this.petrolPrice,
    required this.dieselPrice,
    required this.fuelType,
    required this.lastUpdated,
    required this.address,
    required this.province,
  });
}
