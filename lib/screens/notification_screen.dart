import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/theme_service.dart';
import '../widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const NotificationScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else if (onBack != null) {
                  onBack!();
                }
              },
            ),
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: dummyNotifications.length,
            itemBuilder: (context, index) {
              return NotificationTile(notification: dummyNotifications[index]);
            },
          ),
        );
      },
    );
  }
}
