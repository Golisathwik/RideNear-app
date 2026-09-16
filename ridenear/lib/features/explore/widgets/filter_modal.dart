import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_provider.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  int _activeTabIndex = 0;
  final List<String> _tabs = [
    'Dates',
    'Vehicle Type',
    'Fuel Type',
    'Car Categories',
    'Price Range',
    'Seating'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    provider.clearFilters();
                  },
                  child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Split View
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Tabs
                Container(
                  width: 140,
                  color: theme.scaffoldBackgroundColor,
                  child: ListView.builder(
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final isActive = index == _activeTabIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _activeTabIndex = index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: isActive ? Colors.blue : Colors.transparent,
                                width: 4,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.2)),

                // Right Content
                Expanded(
                  child: Container(
                    color: theme.cardColor,
                    child: _buildRightContent(provider),
                  ),
                ),
              ],
            ),
          ),
          
          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent(AppProvider provider) {
    switch (_activeTabIndex) {
      case 0:
        return _buildDatesTab(provider);
      case 1:
        return _buildOptionsTab(['Car', 'Bike', 'Scooter'], provider.selectedVehicleTypes, provider);
      case 2:
        return _buildOptionsTab(['Petrol', 'Diesel', 'EV'], provider.selectedFuelTypes, provider);
      case 3:
        return _buildOptionsTab(['SUV', 'XUV', 'Premium Cars', 'Sedan', 'Cruiser'], provider.selectedCarCategories, provider);
      case 4:
        return _buildPriceRangeTab(provider);
      case 5:
        return _buildOptionsTab(['2-seaters (Bike)', '4-seaters', '5-seaters', '6-seaters', '7-seaters'], provider.selectedSeats, provider);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDatesTab(AppProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('PICKUP DATE & TIME'),
        const SizedBox(height: 8),
        _buildDateInput(
          provider.pickupDate != null ? '${provider.pickupDate!.day}-${provider.pickupDate!.month}-${provider.pickupDate!.year}' : 'dd-mm-yyyy  --:--',
          () async {
            final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (date != null) provider.setDates(date, provider.returnDate);
          }
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('RETURN DATE & TIME'),
        const SizedBox(height: 8),
        _buildDateInput(
          provider.returnDate != null ? '${provider.returnDate!.day}-${provider.returnDate!.month}-${provider.returnDate!.year}' : 'dd-mm-yyyy  --:--',
          () async {
            final date = await showDatePicker(context: context, initialDate: provider.pickupDate ?? DateTime.now(), firstDate: provider.pickupDate ?? DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (date != null) provider.setDates(provider.pickupDate, date);
          }
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildDateInput(String text, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8), fontSize: 14)),
            Icon(LucideIcons.calendar, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsTab(List<String> options, Set<String> activeSet, AppProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: options.map((option) {
        return Column(
          children: [
            CheckboxListTile(
              title: Text(option, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              value: activeSet.contains(option),
              onChanged: (val) {
                provider.toggleFilter(activeSet, option);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: Colors.blue,
              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeTab(AppProvider provider) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price per day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          RangeSlider(
            values: provider.priceRange,
            min: 0,
            max: 10000,
            divisions: 20,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.2),
            onChanged: (values) {
              provider.setPriceRange(values);
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceBox('Min', '₹${provider.priceRange.start.round()}'),
              const Text('-', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              _buildPriceBox('Max', '₹${provider.priceRange.end.round()}'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPriceBox(String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
        const SizedBox(height: 4),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
