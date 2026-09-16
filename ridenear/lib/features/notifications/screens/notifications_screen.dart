import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            theme,
            icon: LucideIcons.car,
            title: 'Booking Confirmed!',
            subtitle: 'Your Hyundai i20 is ready for pickup.',
            time: '2 hours ago',
            isUnread: true,
          ),
          const Divider(height: 32),
          _buildNotificationItem(
            theme,
            icon: LucideIcons.ticket,
            title: 'Special Offer',
            subtitle: 'Get 20% off on your next SUV booking!',
            time: 'Yesterday',
            isUnread: false,
          ),
          const Divider(height: 32),
          _buildNotificationItem(
            theme,
            icon: LucideIcons.checkCircle,
            title: 'KYC Verified',
            subtitle: 'Your documents have been successfully verified.',
            time: '3 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(ThemeData theme, {required IconData icon, required String title, required String subtitle, required String time, required bool isUnread}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 8),
              Text(time, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
