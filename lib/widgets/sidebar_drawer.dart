import 'package:flutter/material.dart';
import '../models/user.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          // Profile Preview Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(currentUser.avatarUrl),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      currentUser.joinDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(icon: Icons.explore_outlined, label: 'Explore'),
                _DrawerItem(icon: Icons.add_circle_outline, label: 'Add'),
                _DrawerItem(icon: Icons.chat_bubble_outline, label: 'Start Conversation'),
                _DrawerItem(icon: Icons.monetization_on_outlined, label: 'Earn coins'),
                const Divider(color: Colors.white12, indent: 20, endIndent: 20, height: 40),
                _DrawerItem(icon: Icons.info_outline, label: 'About us'),
                _DrawerItem(icon: Icons.privacy_tip_outlined, label: 'Privacy policy'),
                _DrawerItem(icon: Icons.description_outlined, label: 'Terms'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DrawerItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
