import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'home_feed_screen.dart';
import 'add_post_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import '../widgets/sidebar_drawer.dart';
import '../services/theme_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isBottomNavVisible = true;
  DateTime? _lastPressedAt;

  List<Widget> get _screens => [
    const HomeFeedScreen(),
    NotificationScreen(onBack: () => _onItemTapped(0)),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.forward) {
        if (!_isBottomNavVisible) {
          setState(() => _isBottomNavVisible = true);
        }
      } else if (notification.direction == ScrollDirection.reverse) {
        if (_isBottomNavVisible) {
          setState(() => _isBottomNavVisible = false);
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 1. If not on home tab, navigate back to home tab first
        if (_selectedIndex != 0) {
          _onItemTapped(0);
          return;
        }

        // 2. Ask user to press back once more to exit
        final now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit', style: TextStyle(color: Colors.white)),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF1E1E1E),
            ),
          );
          return;
        }

        // 3. Exit app
        await SystemNavigator.pop();
      },
      child: ListenableBuilder(
        listenable: ThemeService(),
        builder: (context, _) {
          final isDark = ThemeService().isDarkMode;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            drawer: SidebarDrawer(
              currentNavIndex: _selectedIndex,
              onNavigateToBottomNav: _onItemTapped,
            ),
            body: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: Stack(
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                  // Floating Animated Bottom Navigation Bar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      offset: _isBottomNavVisible ? Offset.zero : const Offset(0, 1),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 12, 
                          bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _NavBarIcon(
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home_filled,
                              isActive: _selectedIndex == 0,
                              onTap: () => _onItemTapped(0),
                            ),
                            _NavBarIcon(
                              icon: Icons.add,
                              activeIcon: Icons.add,
                              isActive: false, // Pushes a new screen, so it doesn't stay active
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddPostScreen()),
                                );
                              },
                            ),
                            _NavBarIcon(
                              icon: Icons.mail_outline, // Inbox
                              activeIcon: Icons.mail,
                              isActive: _selectedIndex == 1,
                              hasBadge: true,
                              onTap: () => _onItemTapped(1),
                            ),
                            _NavBarIcon(
                              icon: Icons.person_outline,
                              activeIcon: Icons.person,
                              isActive: _selectedIndex == 2,
                              onTap: () => _onItemTapped(2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final bool hasBadge;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService().isDarkMode;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF997DFF) : (isDark ? Colors.white54 : Colors.black54),
              size: 28,
            ),
          ),
          if (hasBadge)
            Positioned(
              right: 18,
              top: 4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF997DFF), // Premium purple-indigo badge
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2), // Cutout effect
                ),
              ),
            ),
        ],
      ),
    );
  }
}
