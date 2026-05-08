import 'package:flutter/material.dart';
import '../models/user.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(currentUser.avatarUrl),
                    backgroundColor: Colors.grey[800],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'u/${currentUser.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, thickness: 1, height: 1),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const _DrawerItem(icon: Icons.home_filled, label: 'Home'),
                  const _DrawerItem(icon: Icons.bookmark_border, label: 'Saved Items'),
                  const _DrawerItem(icon: Icons.list_alt, label: 'My Posts'),
                  const _DrawerItem(icon: Icons.notifications_none, label: 'Notifications'),
                  const Divider(color: Colors.white12, thickness: 1, height: 24),
                  const _DrawerItem(icon: Icons.settings_outlined, label: 'Settings'),
                  const _DrawerItem(icon: Icons.help_outline, label: 'Help'),
                ],
              ),
            ),
            const Divider(color: Colors.white12, thickness: 1, height: 1),
            // Logout
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: _DrawerItem(icon: Icons.logout, label: 'Logout', isLogout: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLogout;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      dense: true,
      leading: Icon(
        icon, 
        color: isLogout ? Colors.redAccent : Colors.white, 
        size: 24
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white, 
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
