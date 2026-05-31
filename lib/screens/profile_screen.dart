import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../services/theme_service.dart';
import '../models/saved_item.dart';
import 'settings_screen.dart';
import 'add_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'PDF', 'Images', 'Videos', 'Links', 'Audio', 'Private'

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SavedItem> _getFilteredItems(List<SavedItem> allItems) {
    final query = _searchQuery.toLowerCase();
    List<SavedItem> results = allItems;

    // 1. Search Query filter
    if (query.isNotEmpty) {
      results = results.where((item) {
        return item.title.toLowerCase().contains(query) ||
            item.content.toLowerCase().contains(query) ||
            item.type.label.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Filter chips selection
    if (_selectedFilter == 'PDF') {
      results = results.where((item) => item.type == SavedItemType.pdf).toList();
    } else if (_selectedFilter == 'Images') {
      results = results.where((item) => item.type == SavedItemType.image).toList();
    } else if (_selectedFilter == 'Videos') {
      results = results.where((item) => item.type == SavedItemType.video).toList();
    } else if (_selectedFilter == 'Links') {
      results = results.where((item) => item.type == SavedItemType.link).toList();
    } else if (_selectedFilter == 'Audio') {
      results = results.where((item) => item.type == SavedItemType.audio).toList();
    } else if (_selectedFilter == 'Private') {
      results = results.where((item) => item.isPrivate).toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockDataService(),
      builder: (context, _) {
        final user = MockDataService().user;
        final userPosts = MockDataService().userPosts;
        final savedItems = MockDataService().savedItems;

        return ListenableBuilder(
          listenable: ThemeService(),
          builder: (context, _) {
            final isDark = ThemeService().isDarkMode;
            final filteredItems = _getFilteredItems(savedItems);

            // Split into two lists for masonry grid layout
            final List<SavedItem> leftColumn = [];
            final List<SavedItem> rightColumn = [];
            for (int i = 0; i < filteredItems.length; i++) {
              if (i % 2 == 0) {
                leftColumn.add(filteredItems[i]);
              } else {
                rightColumn.add(filteredItems[i]);
              }
            }

            return Scaffold(
              backgroundColor: isDark ? const Color(0xFF0F0F12) : const Color(0xFFF8F9FA),
              body: SafeArea(
                child: RefreshIndicator(
                  color: const Color(0xFF7C5CFF),
                  backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 800));
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Header & Statistics wrapper with gradient background
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isDark
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF3A3A42),
                                      Color(0xFF0F0F12),
                                    ],
                                  )
                                : null,
                            color: isDark ? null : Colors.grey[100],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Header
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0, right: 48.0, bottom: 16.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(user.avatarUrl),
                                            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  user.displayName,
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark ? Colors.white : const Color(0xFF1A1D20),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '@${user.username} • ${user.joinDate}',
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    color: isDark ? Colors.white60 : Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  user.bio,
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.settings_outlined,
                                          color: isDark ? Colors.white : const Color(0xFF1A1D20),
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Stats Row
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem('Posts', userPosts.length.toString(), isDark),
                                    _buildVerticalDivider(isDark),
                                    _buildStatItem('Followers', '1.4k', isDark),
                                    _buildVerticalDivider(isDark),
                                    _buildStatItem('Following', '382', isDark),
                                    _buildVerticalDivider(isDark),
                                    _buildStatItem('Likes', '2.9k', isDark),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Search box
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1A1A1F) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                width: 1.0,
                              ),
                              boxShadow: isDark
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF1A1D20),
                                fontSize: 14.5,
                              ),
                              cursorColor: const Color(0xFF7C5CFF),
                              decoration: InputDecoration(
                                hintText: 'Search saved items...',
                                hintStyle: TextStyle(
                                  color: isDark ? Colors.white38 : Colors.black38,
                                  fontSize: 13.5,
                                ),
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF7C5CFF), size: 20),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                        child: const Icon(Icons.clear, size: 16, color: Colors.grey),
                                      )
                                    : null,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Filter chips
                      SliverToBoxAdapter(
                        child: _buildFilterChips(isDark),
                      ),
                      // Grid section
                      if (filteredItems.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open_outlined,
                                  size: 60,
                                  color: isDark ? Colors.white24 : Colors.black26,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No saved items found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Try a different search query'
                                      : 'Tap "+" below to add items to your library',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isDark ? Colors.white38 : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 80.0),
                          sliver: SliverToBoxAdapter(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: leftColumn.map((item) => _buildSavedItemCard(item, isDark)).toList(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    children: rightColumn.map((item) => _buildSavedItemCard(item, isDark)).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 50.0), // elevate slightly above bottom navigation
                child: FloatingActionButton(
                  onPressed: () => _showAddBottomSheet(isDark),
                  backgroundColor: const Color(0xFF7C5CFF),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 6,
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      height: 24,
      width: 1,
      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1D20),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white54 : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ['All', 'PDF', 'Images', 'Videos', 'Links', 'Audio', 'Private'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7C5CFF)
                      : (isDark ? const Color(0xFF1A1A1F) : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF7C5CFF)
                        : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06)),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSavedItemCard(SavedItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: InkWell(
        onTap: () => _showSavedItemDetailsSheet(item, isDark),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Header or icon placeholder
            if (item.thumbnailUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderHeader(item),
                ),
              )
            else
              _buildPlaceholderHeader(item),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1D20),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.type.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.type.icon,
                              size: 10,
                              color: item.type.color,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item.type.label.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: item.type.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Time Saved
                      Text(
                        ' • ${_formatDate(item.dateSaved)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                      // Private indicator
                      if (item.isPrivate)
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Icon(
                            Icons.lock_outline,
                            size: 11,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderHeader(SavedItem item) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: item.type.color.withOpacity(0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Icon(
          item.type.icon,
          color: item.type.color.withOpacity(0.6),
          size: 26,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _formatFullDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showSavedItemDetailsSheet(SavedItem item, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.type.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(item.type.icon, color: item.type.color, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          item.type.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: item.type.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (item.isPrivate)
                    const Row(
                      children: [
                        Icon(Icons.lock, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          'Private Item',
                          style: TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1D20),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Saved on ${_formatFullDate(item.dateSaved)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141416) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: SelectableText(
                  item.content,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Content copied to clipboard!')),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy Info'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1D20),
                        side: BorderSide(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share opened (Mock)')),
                        );
                      },
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C5CFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Create & Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1D20),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C5CFF).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_note_rounded, color: Color(0xFF7C5CFF)),
                  ),
                  title: Text(
                    'Create Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1D20),
                    ),
                  ),
                  subtitle: const Text('Share an update or question in the feed'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddPostScreen()),
                    );
                  },
                ),
                const Divider(height: 24),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF30D158).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark_add_outlined, color: Color(0xFF30D158)),
                  ),
                  title: Text(
                    'Save Item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1D20),
                    ),
                  ),
                  subtitle: const Text('Keep a note, link, video, or PDF in your library'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSaveItemFormSheet(isDark);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSaveItemFormSheet(bool isDark) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    SavedItemType selectedType = SavedItemType.note;
    bool isPrivate = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 24 + keyboardHeight),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Save to Library',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1D20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Item Title',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF141416) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      child: TextField(
                        controller: titleController,
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 14),
                        cursorColor: const Color(0xFF7C5CFF),
                        decoration: InputDecoration(
                          hintText: 'e.g., Python Cheat Sheet',
                          hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38, fontSize: 13.5),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Notes / Link / Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF141416) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      child: TextField(
                        controller: contentController,
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 14),
                        cursorColor: const Color(0xFF7C5CFF),
                        maxLines: 4,
                        minLines: 2,
                        decoration: InputDecoration(
                          hintText: 'e.g., https://github.com or write details...',
                          hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38, fontSize: 13.5),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: SavedItemType.values.map((type) {
                          final isSelected = selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedType = type;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? type.color : (isDark ? const Color(0xFF141416) : Colors.grey[200]),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? type.color
                                        : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      type.icon,
                                      size: 14,
                                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      type.label,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Row(
                        children: [
                          Icon(
                            isPrivate ? Icons.lock : Icons.lock_open,
                            color: isPrivate ? const Color(0xFF7C5CFF) : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Keep item private',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white : const Color(0xFF1A1D20),
                            ),
                          ),
                        ],
                      ),
                      value: isPrivate,
                      activeColor: const Color(0xFF7C5CFF),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          isPrivate = val;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();

                          if (title.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a title')),
                            );
                            return;
                          }

                          String? thumb;
                          if (selectedType == SavedItemType.image) {
                            thumb = 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=600';
                          } else if (selectedType == SavedItemType.video) {
                            thumb = 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?q=80&w=400';
                          }

                          MockDataService().addSavedItem(
                            title,
                            content.isNotEmpty ? content : 'No additional details provided.',
                            selectedType,
                            isPrivate,
                            thumbnailUrl: thumb,
                          );

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"$title" saved to your library!'),
                              backgroundColor: const Color(0xFF30D158),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C5CFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Item',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
