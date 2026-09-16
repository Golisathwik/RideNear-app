import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../../providers/app_provider.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  
  final List<Map<String, dynamic>> _savedLocations = [
    {
      'icon': LucideIcons.clock,
      'title': 'Madhapur',
      'subtitle': 'Hitech City Road, Jubilee Hills, Hyderabad, Telangana 500081',
    },
    {
      'icon': LucideIcons.clock,
      'title': 'Gachibowli',
      'subtitle': 'Financial District, Nanakramguda, Hyderabad, Telangana 500032',
    },
    {
      'icon': LucideIcons.mapPin,
      'title': 'Rajiv Gandhi International Airport',
      'subtitle': 'Shamshabad, Hyderabad, Telangana 500409',
    },
  ];

  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = _savedLocations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = _savedLocations;
        _isSearching = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }
  
  Future<void> _searchPlaces(String query) async {
    setState(() {
      _isSearching = true;
    });
    
    try {
      final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5';
      
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'CarRentalsApp/1.0',
      });
      
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        
        setState(() {
          _searchResults = data.map((item) {
            final address = item['address'] ?? {};
            final title = address['city'] ?? address['town'] ?? address['suburb'] ?? address['village'] ?? item['name'];
            final subtitle = item['display_name'];
            
            return {
              'icon': LucideIcons.mapPin,
              'title': title,
              'subtitle': subtitle,
              'lat': double.tryParse(item['lat'] ?? ''),
              'lon': double.tryParse(item['lon'] ?? ''),
              'full_address': subtitle,
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // Need it to fill most of the screen like the screenshot
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Text(
                  'Select Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 24), // Balance the flex
              ],
            ),
          ),
          const Divider(height: 1),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for area, street name...',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
            ),
          ),

          // Use Current Location
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
              child: Icon(LucideIcons.navigation, color: theme.colorScheme.onSurface, size: 20),
            ),
            title: const Text('Use current location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Using GPS', style: TextStyle(fontSize: 12)),
            onTap: () {
              context.read<AppProvider>().fetchCurrentLocation();
              Navigator.pop(context);
            },
          ),

          const Divider(height: 32, color: Colors.transparent), // Transparent for spacing

          // Saved & Recent Locations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'SAVED & RECENT LOCATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),

          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final loc = _searchResults[index];
                      return _buildLocationItem(
                        context,
                        icon: loc['icon'] as IconData,
                        title: loc['title'] as String,
                        subtitle: loc['subtitle'] as String,
                        lat: loc['lat'] as double?,
                        lon: loc['lon'] as double?,
                        fullAddress: loc['full_address'] as String?,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(BuildContext context, {required IconData icon, required String title, required String subtitle, double? lat, double? lon, String? fullAddress}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            context.read<AppProvider>().setLocation(title, subtitle, lat: lat, lon: lon, fullAddress: fullAddress ?? "\$title, \$subtitle");
            Navigator.pop(context);
          },
        ),
        Divider(height: 1, indent: 56, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }
}
