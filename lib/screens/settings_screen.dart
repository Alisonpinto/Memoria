import 'package:flutter/material.dart';
import '../services/theme_service.dart';

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
  void initState() {
    super.initState();
    _darkMode = ThemeService().isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService().isDarkMode;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1D20))),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            value: _darkMode,
            activeColor: const Color(0xFF997DFF),
            onChanged: (val) {
              setState(() => _darkMode = val);
              ThemeService().toggleTheme(val);
            },
          ),
          ListTile(
            title: Text('Accent Color', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF997DFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Divider(color: dividerColor),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: Text('Push Notifications', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            value: _pushNotifications,
            activeColor: const Color(0xFF997DFF),
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          SwitchListTile(
            title: Text('Email Notifications', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            value: _emailNotifications,
            activeColor: const Color(0xFF997DFF),
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),

          Divider(color: dividerColor),
          _buildSectionHeader('Privacy'),
          SwitchListTile(
            title: Text('Private Profile', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            subtitle: Text('Only approved followers can see your posts', style: TextStyle(color: secondaryTextColor, fontSize: 12)),
            value: _privateProfile,
            activeColor: const Color(0xFF997DFF),
            onChanged: (val) => setState(() => _privateProfile = val),
          ),
          SwitchListTile(
            title: Text('Anonymous Posting', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            value: _anonymousPosting,
            activeColor: const Color(0xFF997DFF),
            onChanged: (val) => setState(() => _anonymousPosting = val),
          ),

          Divider(color: dividerColor),
          _buildSectionHeader('Account'),
          ListTile(
            title: Text('Edit Profile', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Icon(Icons.chevron_right, color: secondaryTextColor),
            onTap: () {},
          ),
          ListTile(
            title: Text('Change Username', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Icon(Icons.chevron_right, color: secondaryTextColor),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out (Mock)')));
            },
          ),

          Divider(color: dividerColor),
          _buildSectionHeader('About'),
          ListTile(
            title: Text('App Version', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Text('1.0.0 (Beta)', style: TextStyle(color: secondaryTextColor)),
          ),
          ListTile(
            title: Text('Terms & Privacy', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Icon(Icons.open_in_new, color: secondaryTextColor, size: 18),
            onTap: () {},
          ),
          ListTile(
            title: Text('Help & Support', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            trailing: Icon(Icons.open_in_new, color: secondaryTextColor, size: 18),
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
          color: Color(0xFF997DFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
