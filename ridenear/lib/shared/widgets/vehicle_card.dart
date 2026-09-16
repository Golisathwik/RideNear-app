import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../models/vehicle.dart';
import '../../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../features/vehicle_details/screens/vehicle_details_screen.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSaved = context.watch<AppProvider>().isSaved(vehicle.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  vehicle.image,
                  height: 140, // Reduced height for image
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: vehicle.available ? theme.colorScheme.secondary : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vehicle.available ? 'Available' : 'Limited',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => context.read<AppProvider>().toggleSaved(vehicle.id),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    radius: 14,
                    child: Icon(
                      isSaved ? Icons.favorite : LucideIcons.heart,
                      color: isSaved ? Colors.red : theme.colorScheme.onSurface,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.category,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vehicle.name,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Rating, Vendor, Distance
                Row(
                  children: [
                    Icon(LucideIcons.star, size: 12, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${vehicle.vendor.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey))),
                    Text(vehicle.vendor.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                    if (vehicle.vendor.verified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(LucideIcons.shieldCheck, size: 12, color: Colors.blue),
                      ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey))),
                    Icon(LucideIcons.mapPin, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 2),
                    Text(vehicle.distance, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Specs
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpec(vehicle.transmission, theme),
                      Container(width: 1, height: 12, color: theme.dividerColor.withOpacity(0.2)),
                      _buildSpec(vehicle.fuel, theme),
                      Container(width: 1, height: 12, color: theme.dividerColor.withOpacity(0.2)),
                      _buildSpec('${vehicle.seats} Seats', theme),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Actions (Price + Book Now)
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${(vehicle.pricePerDay * 0.7).round()} / 12h',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '₹${vehicle.pricePerDay} / 24h',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailsScreen(vehicle: vehicle)));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Book Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpec(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }
}
