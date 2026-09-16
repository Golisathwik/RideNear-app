import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../providers/app_provider.dart';
import 'edit_profile_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AppProvider>();
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profile?.imageUrl ?? ''),
                backgroundColor: theme.primaryColor.withOpacity(0.1),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    profile?.name ?? 'Guest User',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile?.phone ?? ''}  •  ${profile?.email ?? ''}',
                    style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildMenuItem(LucideIcons.userCircle, 'Edit Profile', theme, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
          _buildMenuItem(LucideIcons.shieldCheck, 'KYC Status', theme, badge: 'Verified', badgeColor: Colors.green),
          _buildMenuItem(LucideIcons.creditCard, 'Saved Payment Methods', theme, onTap: () => _showPaymentMethods(context)),
          _buildMenuItem(LucideIcons.bell, 'Notifications', theme, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          _buildMenuItem(LucideIcons.helpCircle, 'Help & Support', theme),
          _buildMenuItem(LucideIcons.fileText, 'Terms & Conditions', theme),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(LucideIcons.logOut, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              context.read<AppProvider>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, ThemeData theme, {String? badge, Color? badgeColor, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor?.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 20),
        ],
      ),
      onTap: onTap ?? () {},
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saved Payment Methods', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(LucideIcons.creditCard, color: Colors.blue),
              title: const Text('HDFC Bank Credit Card'),
              subtitle: const Text('**** **** **** 1234'),
              trailing: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(LucideIcons.plusCircle, color: Colors.green),
              title: const Text('Add New Card', style: TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card added successfully')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
