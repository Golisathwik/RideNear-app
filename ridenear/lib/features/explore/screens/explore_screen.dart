import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../data/mock/mock_data.dart';
import '../../../shared/widgets/vehicle_card.dart';
import '../../map/screens/map_screen.dart'; 
import '../widgets/location_modal.dart';
import '../widgets/filter_modal.dart';

import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';
import '../../notifications/screens/notifications_screen.dart';

class ExploreScreen extends StatefulWidget {
  final ScrollController? scrollController;
  
  const ExploreScreen({super.key, this.scrollController});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _activeCategory = 'all';
  bool _isMapView = false;

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationModal(),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();
    final filteredVehicles = provider.getFilteredVehicles(MockData.vehicles, _activeCategory);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: widget.scrollController,
              slivers: [
                // Top Location Bar (Disappears on scroll)
                SliverAppBar(
                  floating: true,
                  snap: false,
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  toolbarHeight: 70,
                  title: GestureDetector(
                    onTap: _showLocationBottomSheet,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Icon(LucideIcons.mapPin, color: theme.primaryColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: provider.isFetchingLocation 
                            ? const Row(
                                children: [
                                  SizedBox(
                                    height: 16, width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Locating...', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          provider.currentLocation,
                                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(LucideIcons.chevronDown, size: 16),
                                    ],
                                  ),
                                  Text(
                                    provider.currentCity,
                                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.bell),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                          },
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Search Bar and Filters (Pinned on scroll)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 130, // 70 for search + 60 for categories
                    maxHeight: 130,
                    child: Container(
                      color: theme.scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(LucideIcons.search, size: 20),
                                        suffixIcon: const Icon(LucideIcons.mic, size: 20),
                                        hintText: 'Search cars, bikes...',
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: (provider.pickupDate != null) ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: (provider.pickupDate != null) ? theme.primaryColor : Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: IconButton(
                                        icon: Icon(LucideIcons.calendar, size: 20, color: (provider.pickupDate != null) ? theme.primaryColor : null),
                                        onPressed: () async {
                                          final dates = await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(const Duration(days: 365)),
                                            initialDateRange: provider.pickupDate != null && provider.returnDate != null
                                                ? DateTimeRange(start: provider.pickupDate!, end: provider.returnDate!)
                                                : null,
                                          );
                                          if (dates != null) {
                                            context.read<AppProvider>().setDates(dates.start, dates.end);
                                          }
                                        },
                                      ),
                                    ),
                                    if (provider.pickupDate != null)
                                      Positioned(
                                        right: -4,
                                        top: -4,
                                        child: IconButton(
                                          icon: Container(
                                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(LucideIcons.x, size: 10, color: Colors.white),
                                          ),
                                          onPressed: () => context.read<AppProvider>().setDates(null, null),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(LucideIcons.slidersHorizontal, size: 20),
                                    onPressed: _showFilterBottomSheet,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildCategories(theme),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content (List or Map)
                if (_isMapView)
                  SliverFillRemaining(
                    child: MockMapScreen(
                      vehicles: filteredVehicles,
                      initialLat: provider.userLatitude,
                      initialLng: provider.userLongitude,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // padding for bottom nav
                    sliver: filteredVehicles.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text('No vehicles match your filters.', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return VehicleCard(vehicle: filteredVehicles[index]);
                            },
                            childCount: filteredVehicles.length,
                          ),
                        ),
                  ),
              ],
            ),

            // Floating Toggle (Map/List)
            Positioned(
              bottom: 90, // above the floating bottom nav
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isMapView = !_isMapView),
                  icon: Icon(_isMapView ? LucideIcons.list : LucideIcons.map, color: Colors.white, size: 18),
                  label: Text(_isMapView ? 'List View' : 'Map View', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: MockData.categories.length,
        itemBuilder: (context, index) {
          final cat = MockData.categories[index];
          final isActive = _activeCategory == cat['id'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(cat['label']!),
              selected: isActive,
              onSelected: (selected) {
                if (selected) setState(() => _activeCategory = cat['id']!);
              },
              backgroundColor: theme.cardColor,
              selectedColor: theme.primaryColor,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: isActive ? theme.primaryColor : theme.dividerColor.withOpacity(0.2)),
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
