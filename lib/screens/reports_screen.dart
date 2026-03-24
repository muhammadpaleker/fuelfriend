import 'package:flutter/material.dart';
import '../data/stations_data.dart';
import '../../models/station.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Station? _selectedStation;
  String _selectedProvince = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _reportTypes = [
    'Price recently increased',
    'Station is very busy / long queue',
    'Out of diesel',
    'Out of petrol',
    'Long wait for pump',
    'Other issue',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Station> get _filteredStations {
    return allStations.where((s) {
      final matchesProvince =
          _selectedProvince == 'All' || s.province == _selectedProvince;
      final matchesSearch =
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesProvince && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedStation == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
          backgroundColor: const Color(0xFF005BB0),
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: (value) => setState(() => _selectedProvince = value),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'All', child: Text('All')),
                PopupMenuItem(value: 'Gauteng', child: Text('Gauteng')),
                PopupMenuItem(
                  value: 'Western Cape',
                  child: Text('Western Cape'),
                ),
                PopupMenuItem(
                  value: 'KwaZulu-Natal',
                  child: Text('KwaZulu-Natal'),
                ),
                PopupMenuItem(
                  value: 'Eastern Cape',
                  child: Text('Eastern Cape'),
                ),
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
              child: ListTile(
                leading: const Icon(
                  Icons.local_gas_station,
                  color: Color(0xFF005BB0),
                  size: 40,
                ),
                title: Text(station.name),
                subtitle: Text(station.address),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() => _selectedStation = station);
                },
              ),
            );
          },
        ),
      );
    }

    // Report selection view
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: const Color(0xFF005BB0),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Station: ${_selectedStation!.name}'),
            subtitle: Text(_selectedStation!.address),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _reportTypes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.report_problem,
                    color: Colors.orange,
                  ),
                  title: Text(_reportTypes[index]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reported: ${_reportTypes[index]}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() => _selectedStation = null);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
