import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/stations_data.dart';
import '../../models/station.dart';
import '../../widgets/station_bottom_sheet.dart';
import '../../widgets/nearest_stations_sheet.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-33.9249, 18.4241),
    zoom: 11,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _loadDummyStations() {
    final newMarkers = allStations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: station.position,
        infoWindow: InfoWindow(
          title: station.name,
          snippet:
              'Petrol: R${station.petrolPrice} | Diesel: R${station.dieselPrice}',
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => StationBottomSheet(station: station),
          );
        },
      );
    }).toSet();

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }

  Future<void> _showStationsNearMe() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Station> stations = List.from(allStations);

    stations.sort((a, b) {
      if (a.petrolPrice != b.petrolPrice) {
        return a.petrolPrice.compareTo(b.petrolPrice);
      }
      return a.dieselPrice.compareTo(b.dieselPrice);
    });

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => NearestStationsSheet(
        stations: stations.take(5).toList(),
        userPosition: position,
      ),
    );
  }

  Future<void> _startAddStationFlow() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Station feature coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FuelFriend Map'),
        backgroundColor: const Color(0xFF005BB0),
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
          _loadDummyStations();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: 'addStation',
              onPressed: _startAddStationFlow,
              backgroundColor: Colors.green[700],
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Add Station'),
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              heroTag: 'nearMe',
              onPressed: _showStationsNearMe,
              backgroundColor: const Color(0xFF005BB0),
              icon: const Icon(Icons.my_location),
              label: const Text('Near Me'),
            ),
          ],
        ),
      ),
    );
  }
}
