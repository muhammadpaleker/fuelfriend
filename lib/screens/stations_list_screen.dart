import 'package:flutter/material.dart';
import '../data/stations_data.dart';
import '../../models/station.dart';

class StationsListScreen extends StatefulWidget {
  const StationsListScreen({super.key});

  @override
  State<StationsListScreen> createState() => _StationsListScreenState();
}

class _StationsListScreenState extends State<StationsListScreen> {
  String _selectedProvince = 'All';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Station> get _filteredStations {
    return allStations.where((station) {
      final matchesProvince =
          _selectedProvince == 'All' || station.province == _selectedProvince;
      final matchesSearch =
          station.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          station.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesProvince && matchesSearch;
    }).toList()..sort((a, b) => a.petrolPrice.compareTo(b.petrolPrice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Stations'),
        backgroundColor: const Color(0xFF005BB0),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _selectedProvince = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Gauteng', child: Text('Gauteng')),
              PopupMenuItem(value: 'Western Cape', child: Text('Western Cape')),
              PopupMenuItem(
                value: 'KwaZulu-Natal',
                child: Text('KwaZulu-Natal'),
              ),
              PopupMenuItem(value: 'Eastern Cape', child: Text('Eastern Cape')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search stations...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredStations.length,
        itemBuilder: (context, index) {
          final station = _filteredStations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.local_gas_station,
                color: Color(0xFF005BB0),
                size: 40,
              ),
              title: Text(
                station.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${station.address} • ${station.province}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Petrol  R${station.petrolPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Diesel  R${station.dieselPrice.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
