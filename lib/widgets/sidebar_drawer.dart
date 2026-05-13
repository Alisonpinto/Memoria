import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/add_post_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../services/theme_service.dart';

class SidebarDrawer extends StatelessWidget {
  final int currentNavIndex;
  final Function(int)? onNavigateToBottomNav;

  const SidebarDrawer({
    super.key,
    this.currentNavIndex = 0,
    this.onNavigateToBottomNav,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        final dividerColor = isDark ? Colors.white12 : Colors.black12;

        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: Column(
              children: [
                // Profile Section
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    if (onNavigateToBottomNav != null) {
                      onNavigateToBottomNav!(2); // Profile is index 2
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    }
                  },
                  child: Padding(
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1A1D20),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'u/${currentUser.username}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: dividerColor, thickness: 1, height: 1),
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _DrawerItem(
                        icon: Icons.home_filled, 
                        label: 'Home', 
                        isActive: currentNavIndex == 0,
                        onTap: () {
                          Navigator.pop(context);
                          onNavigateToBottomNav?.call(0);
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.add_box_outlined, 
                        label: 'Create Post',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPostScreen()));
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.notifications_none, 
                        label: 'Notifications',
                        isActive: currentNavIndex == 1,
                        onTap: () {
                          Navigator.pop(context);
                          onNavigateToBottomNav?.call(1);
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.person_outline, 
                        label: 'Profile',
                        isActive: currentNavIndex == 2,
                        onTap: () {
                          Navigator.pop(context);
                          onNavigateToBottomNav?.call(2);
                        },
                      ),
                      Divider(color: dividerColor, thickness: 1, height: 24),
                      _DrawerItem(
                        icon: Icons.bookmark_border, 
                        label: 'Saved Items',
                        onTap: () {
                          Navigator.pop(context);
                          if (onNavigateToBottomNav != null) {
                             onNavigateToBottomNav!(2); 
                          }
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.settings_outlined, 
                        label: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.help_outline, 
                        label: 'Help',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help opens here')));
                        },
                      ),
                    ],
                  ),
                ),
                Divider(color: dividerColor, thickness: 1, height: 1),
                // Logout
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _DrawerItem(
                    icon: Icons.logout, 
                    label: 'Logout', 
                    isLogout: true,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out (Mock)')));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLogout;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService().isDarkMode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF997DFF).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        leading: Icon(
          icon, 
          color: isLogout 
              ? Colors.redAccent 
              : isActive 
                  ? const Color(0xFF997DFF) 
                  : (isDark ? Colors.white70 : Colors.black87), 
          size: 24
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isLogout 
                ? Colors.redAccent 
                : isActive 
                    ? const Color(0xFF997DFF) 
                    : (isDark ? Colors.white : const Color(0xFF1A1D20)), 
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
