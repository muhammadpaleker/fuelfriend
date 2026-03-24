import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-28.0, 24.0), // Rough center of South Africa
    zoom: 5.0,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Add a dummy marker (example: Cape Town station)
    _markers.add(
      Marker(
        markerId: MarkerId('cpt_station'),
        position: LatLng(-33.9249, 18.4241),
        infoWindow: InfoWindow(
          title: 'Cape Town - TotalEnergies',
          snippet: 'Petrol: R22.45 | Diesel: R23.10',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petrol Price ZA Map'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        myLocationEnabled: true, // Will ask for location permission in real app
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          // You can save the controller if needed later (e.g. for animations)
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Later: open search or filters
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search / Filter coming soon')),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
