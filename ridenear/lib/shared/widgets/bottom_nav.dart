import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../providers/app_provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, index: 0, icon: LucideIcons.compass, label: 'Explore', isActive: provider.currentTabIndex == 0),
            _buildNavItem(context, index: 1, icon: LucideIcons.history, label: 'Bookings', isActive: provider.currentTabIndex == 1),
            _buildNavItem(context, index: 2, icon: LucideIcons.heart, label: 'Saved', isActive: provider.currentTabIndex == 2),
            _buildNavItem(context, index: 3, icon: LucideIcons.user, label: 'Profile', isActive: provider.currentTabIndex == 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required int index, required IconData icon, required String label, required bool isActive}) {
    final theme = Theme.of(context);
    final color = isActive ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.4);

    return InkWell(
      onTap: () => context.read<AppProvider>().setTabIndex(index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
