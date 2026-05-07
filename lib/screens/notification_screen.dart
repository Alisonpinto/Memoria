import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
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
  }
}
