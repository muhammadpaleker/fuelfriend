import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/station.dart';
import 'station_bottom_sheet.dart';

class NearestStationsSheet extends StatelessWidget {
  final List<Station> stations;
  final Position userPosition;

  const NearestStationsSheet({
    super.key,
    required this.stations,
    required this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 42,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Nearest Gas Stations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    final distanceMeters = Geolocator.distanceBetween(
                      userPosition.latitude,
                      userPosition.longitude,
                      station.position.latitude,
                      station.position.longitude,
                    );
                    final distanceKm = (distanceMeters / 1000).toStringAsFixed(
                      1,
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.local_gas_station,
                          color: Color(0xFF005BB0),
                          size: 32,
                        ),
                        title: Text(
                          station.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('$distanceKm km • ${station.address}'),
                        trailing: Text(
                          'R${station.petrolPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        onTap: () {
                          // Close the near-me sheet
                          Navigator.pop(context);
                          // Open the detailed station bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) =>
                                StationBottomSheet(station: station),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
