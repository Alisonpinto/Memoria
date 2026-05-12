import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock settings state
  bool _darkMode = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _privateProfile = false;
  bool _anonymousPosting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            activeColor: const Color(0xFF7C5CFF),
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          ListTile(
            title: const Text('Accent Color'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF7C5CFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          const Divider(color: Colors.white12),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            activeColor: const Color(0xFF7C5CFF),
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            activeColor: const Color(0xFF7C5CFF),
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),

          const Divider(color: Colors.white12),
          _buildSectionHeader('Privacy'),
          SwitchListTile(
            title: const Text('Private Profile'),
            subtitle: const Text('Only approved followers can see your posts', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _privateProfile,
            activeColor: const Color(0xFF7C5CFF),
            onChanged: (val) => setState(() => _privateProfile = val),
          ),
          SwitchListTile(
            title: const Text('Anonymous Posting'),
            value: _anonymousPosting,
            activeColor: const Color(0xFF7C5CFF),
            onChanged: (val) => setState(() => _anonymousPosting = val),
          ),

          const Divider(color: Colors.white12),
          _buildSectionHeader('Account'),
          ListTile(
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Change Username'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out (Mock)')));
            },
          ),

          const Divider(color: Colors.white12),
          _buildSectionHeader('About'),
          const ListTile(
            title: Text('App Version'),
            trailing: Text('1.0.0 (Beta)', style: TextStyle(color: Colors.white54)),
          ),
          ListTile(
            title: const Text('Terms & Privacy'),
            trailing: const Icon(Icons.open_in_new, color: Colors.white54, size: 18),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.open_in_new, color: Colors.white54, size: 18),
            onTap: () {},
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF7C5CFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
