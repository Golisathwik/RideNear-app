import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/vehicle.dart';
import '../../../providers/app_provider.dart';
import '../../../shared/widgets/vehicle_card.dart';

class MockMapScreen extends StatefulWidget {
  final List<Vehicle> vehicles;
  final double initialLat;
  final double initialLng;

  const MockMapScreen({super.key, required this.vehicles, required this.initialLat, required this.initialLng});

  @override
  State<MockMapScreen> createState() => _MockMapScreenState();
}

class _MockMapScreenState extends State<MockMapScreen> {
  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void didUpdateWidget(MockMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialLat != widget.initialLat || oldWidget.initialLng != widget.initialLng) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(widget.initialLat, widget.initialLng)),
      );
    }
  }

  void _showVehicleBottomSheet(BuildContext context, Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              VehicleCard(vehicle: vehicle),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = widget.vehicles.map((vehicle) {
      return Marker(
        markerId: MarkerId(vehicle.id),
        position: LatLng(vehicle.vendor.latitude, vehicle.vendor.longitude),
        infoWindow: InfoWindow(
          title: vehicle.vendor.name,
          snippet: vehicle.name,
        ),
        onTap: () {
          _showVehicleBottomSheet(context, vehicle);
        },
      );
    }).toSet();

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLat, widget.initialLng),
            zoom: 14.0,
          ),
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
          },
        ),
        Positioned(
          bottom: 120, // Avoid bottom nav bar
          right: 16,
          child: FloatingActionButton(
            heroTag: 'recenter_gps',
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () async {
              // Fetch actual physical GPS location, not just the selected city
              final provider = context.read<AppProvider>();
              await provider.fetchCurrentLocation();
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(provider.userLatitude, provider.userLongitude), 
                  14.0
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
