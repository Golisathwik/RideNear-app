import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';
import '../../../models/vehicle.dart';
import '../../booking/screens/booking_screen.dart'; // Will create next

class VehicleDetailsScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240, // Reduced from 300
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.8),
                child: IconButton(
                  icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                vehicle.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.category,
                            style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            vehicle.name,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${(vehicle.pricePerDay * 0.7).round()} / 12h',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold, 
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              '₹${vehicle.pricePerDay} / 24h',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold, 
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor ?? Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailItem('Transmission', vehicle.transmission, theme),
                        Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.2)),
                        _buildDetailItem('Fuel', vehicle.fuel, theme),
                        Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.2)),
                        _buildDetailItem('Seats', '${vehicle.seats}', theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Vendor Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(LucideIcons.shieldCheck, color: theme.colorScheme.secondary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(vehicle.vendor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  if (vehicle.vendor.verified)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(LucideIcons.shieldCheck, size: 14, color: theme.colorScheme.secondary),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(LucideIcons.star, size: 12, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text('${vehicle.vendor.rating} (${vehicle.vendor.reviews} reviews)', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final lat = vehicle.vendor.latitude;
                            final lng = vehicle.vendor.longitude;
                            final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.inputDecorationTheme.fillColor ?? Colors.grey.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(LucideIcons.mapPin, color: theme.primaryColor, size: 16),
                                const SizedBox(height: 2),
                                const Text('Directions', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Availability', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: Builder(builder: (context) {
                      final provider = context.watch<AppProvider>();
                      
                      bool isDayBlocked(DateTime day) {
                        // Check if there's any available 12-hour slot between 6 AM and 10 PM
                        for (int hour = 6; hour <= 22; hour += 2) {
                          DateTime start = DateTime(day.year, day.month, day.day, hour);
                          DateTime end = start.add(const Duration(hours: 12));
                          if (provider.isTimeSlotAvailable(vehicle.id, start, end)) {
                            return false; // Found an available slot
                          }
                        }
                        return true; // Fully blocked
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(Duration(days: index));
                          final isBlocked = isDayBlocked(date);
                          
                          return GestureDetector(
                            onTap: () {
                              if (!isBlocked) {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(vehicle: vehicle, initialDate: date)));
                              }
                            },
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isBlocked ? Colors.grey.withOpacity(0.1) : theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isBlocked ? Colors.grey.withOpacity(0.3) : theme.primaryColor.withOpacity(0.5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_getShortMonth(date.month), style: TextStyle(fontSize: 10, color: isBlocked ? Colors.grey : theme.primaryColor)),
                                  Text('${date.day}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isBlocked ? Colors.grey : theme.primaryColor, decoration: isBlocked ? TextDecoration.lineThrough : null)),
                                  if (isBlocked) const Text('Booked', style: TextStyle(fontSize: 8, color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(vehicle: vehicle)));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Proceed to Book', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, ThemeData theme) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  String _getShortMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
