import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';
import '../services/theme_service.dart';
import '../widgets/post_card.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder( 
      listenable: MockDataService(),
      builder: (context, _) {
        final user = MockDataService().user;
        final userPosts = MockDataService().userPosts;
        final savedPosts = MockDataService().savedPosts;

        return ListenableBuilder(
          listenable: ThemeService(),
          builder: (context, _) {
            final isDark = ThemeService().isDarkMode;
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  centerTitle: false,
                  title: Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? Colors.white : const Color(0xFF1A1D20),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings_outlined, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      },
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  color: const Color(0xFF997DFF),
                  backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 800));
                  },
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar and Stats Row
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(user.avatarUrl),
                                          backgroundColor: Colors.grey[800],
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Edit Profile opened (Mock)')),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF997DFF),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          _StatItem(label: 'Posts', value: '0'),
                                          _StatItem(label: 'Saved Items', value: '0'),
                                          _StatItem(label: 'Likes', value: '0'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Display Name & Join Date
                                Text(
                                  user.displayName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF1A1D20),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.joinDate,
                                  style: TextStyle(
                                    color: isDark ? Colors.white54 : Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              indicatorColor: const Color(0xFF997DFF),
                              labelColor: isDark ? Colors.white : const Color(0xFF1A1D20),
                              unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
                              tabs: const [
                                Tab(icon: Icon(Icons.grid_on)),
                                Tab(icon: Icon(Icons.bookmark_outline)),
                                Tab(icon: Icon(Icons.person_pin_outlined)),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        _buildPostList(userPosts, "No posts yet", "When you share photos, they will appear here.", Icons.camera_alt_outlined),
                        _buildPostList(savedPosts, "No saved posts", "Saved posts will appear here.", Icons.bookmark_border),
                        _buildEmptyState("No tagged posts", "When people tag you, it will show up here.", Icons.person_pin_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPostList(List posts, String emptyTitle, String emptySubtitle, IconData emptyIcon) {
    if (posts.isEmpty) {
      return _buildEmptyState(emptyTitle, emptySubtitle, emptyIcon);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    final isDark = ThemeService().isDarkMode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: isDark ? Colors.white24 : Colors.black38),
        const SizedBox(height: 16),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.black54)),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: isDark ? Colors.white38 : Colors.black38)),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = ThemeService().isDarkMode;
    return Container(
      color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F9FA),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService().isDarkMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D20))),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13)),
      ],
    );
  }
}
