import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/mock/mock_data.dart';
import '../../../providers/app_provider.dart';
import '../../../shared/widgets/vehicle_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedIds = context.watch<AppProvider>().savedVehicleIds;
    final savedVehicles = MockData.vehicles.where((v) => savedIds.contains(v.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Vehicles', style: TextStyle(fontWeight: FontWeight.bold))),
      body: savedVehicles.isEmpty
          ? const Center(child: Text('No saved vehicles yet.', style: TextStyle(fontWeight: FontWeight.w500)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedVehicles.length,
              itemBuilder: (context, index) {
                return VehicleCard(vehicle: savedVehicles[index]);
              },
            ),
    );
  }
}
