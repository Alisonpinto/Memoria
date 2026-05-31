import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class CommunitySaveItem {
  final String title;
  final String category;
  final String platform;
  final String saveCount;
  final String thumbnailUrl;
  final String type; // 'Product', 'Note', 'PDF', 'Book', 'Link', 'Music'

  CommunitySaveItem({
    required this.title,
    required this.category,
    required this.platform,
    required this.saveCount,
    required this.thumbnailUrl,
    required this.type,
  });
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Products', 'Notes & PDFs', 'Links & Books'
  
  final List<String> _recentSearches = [
    'Clean Architecture',
    'Mechanical Keyboard',
    'Figma UI Kit',
    'Lo-Fi Beats',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Books',
      'icon': Icons.book_rounded,
      'gradient': const [Color(0xFFFF5E3A), Color(0xFFFF2A68)],
    },
    {
      'name': 'Fashion',
      'icon': Icons.checkroom_rounded,
      'gradient': const [Color(0xFFEE9AE5), Color(0xFF5961F9)],
    },
    {
      'name': 'Tech',
      'icon': Icons.laptop_chromebook_rounded,
      'gradient': const [Color(0xFF00C6FF), Color(0xFF0072FF)],
    },
    {
      'name': 'Notes',
      'icon': Icons.description_rounded,
      'gradient': const [Color(0xFF13F1FC), Color(0xFF0470DC)],
    },
    {
      'name': 'Education',
      'icon': Icons.school_rounded,
      'gradient': const [Color(0xFFB194F6), Color(0xFF7C5CFF)],
    },
    {
      'name': 'Cycling',
      'icon': Icons.directions_bike_rounded,
      'gradient': const [Color(0xFFFDC830), Color(0xFFF37335)],
    },
    {
      'name': 'Gaming',
      'icon': Icons.sports_esports_rounded,
      'gradient': const [Color(0xFFF857A6), Color(0xFFFF5858)],
    },
    {
      'name': 'Music',
      'icon': Icons.music_note_rounded,
      'gradient': const [Color(0xFF45B649), Color(0xFFDCE35B)],
    },
  ];

  final List<CommunitySaveItem> _savedItems = [
    CommunitySaveItem(
      title: 'Python Data Science Handbook',
      category: 'Books',
      platform: 'O\'Reilly Media',
      saveCount: '428 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=150',
      type: 'Book',
    ),
    CommunitySaveItem(
      title: 'Figma iOS 17 UI Design System Kit',
      category: 'Tech',
      platform: 'Figma Community',
      saveCount: '1.2k saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=150',
      type: 'Link',
    ),
    CommunitySaveItem(
      title: 'Road Cycling Training Plan',
      category: 'Cycling',
      platform: 'CyclingAcademy',
      saveCount: '86 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?q=80&w=150',
      type: 'PDF',
    ),
    CommunitySaveItem(
      title: 'Retro Oversized Corduroy Jacket',
      category: 'Fashion',
      platform: 'ASOS Marketplace',
      saveCount: '245 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=150',
      type: 'Product',
    ),
    CommunitySaveItem(
      title: 'Machine Learning Stanford Lecture Notes',
      category: 'Notes',
      platform: 'Stanford Online',
      saveCount: '980 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=150',
      type: 'Note',
    ),
    CommunitySaveItem(
      title: 'Full-Stack Developer Roadmap 2026',
      category: 'Education',
      platform: 'Roadmap.sh',
      saveCount: '2.4k saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=150',
      type: 'Link',
    ),
    CommunitySaveItem(
      title: 'Keychron K4 Wireless Mechanical Keyboard',
      category: 'Tech',
      platform: 'Keychron',
      saveCount: '312 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?q=80&w=150',
      type: 'Product',
    ),
    CommunitySaveItem(
      title: 'Synthwave Chill Study Playlist',
      category: 'Music',
      platform: 'Spotify',
      saveCount: '640 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=150',
      type: 'Music',
    ),
    CommunitySaveItem(
      title: 'Elden Ring Ultimate Strategy Guide Book',
      category: 'Gaming',
      platform: 'IGN Wiki',
      saveCount: '534 saves',
      thumbnailUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?q=80&w=150',
      type: 'Book',
    ),
  ];

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
    _focusNode.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
    setState(() {
      _searchController.text = query;
      _searchQuery = query;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
      _focusNode.unfocus();
      
      // Add to recent searches if not already present
      if (query.isNotEmpty && !_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 6) {
          _recentSearches.removeLast();
        }
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  List<CommunitySaveItem> _getFilteredItems() {
    final query = _searchQuery.toLowerCase();
    
    // 1. Initial filter by query
    List<CommunitySaveItem> results = _savedItems;
    if (query.isNotEmpty) {
      results = _savedItems.where((item) {
        final titleMatch = item.title.toLowerCase().contains(query);
        final categoryMatch = item.category.toLowerCase().contains(query);
        final platformMatch = item.platform.toLowerCase().contains(query);
        final typeMatch = item.type.toLowerCase().contains(query);
        return titleMatch || categoryMatch || platformMatch || typeMatch;
      }).toList();
    }

    // 2. Filter by selected chip tab
    if (_selectedFilter == 'Products') {
      results = results.where((item) => item.type == 'Product').toList();
    } else if (_selectedFilter == 'Notes & PDFs') {
      results = results.where((item) => item.type == 'Note' || item.type == 'PDF').toList();
    } else if (_selectedFilter == 'Links & Books') {
      results = results.where((item) => item.type == 'Link' || item.type == 'Book').toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        final theme = Theme.of(context);
        final accentColor = const Color(0xFF7C5CFF); // Premium purple-indigo accent
        
        final filteredItems = _getFilteredItems();
        final isSearching = _searchQuery.isNotEmpty;
        
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : const Color(0xFF1A1D20),
                size: 26,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(
              'Discover',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1A1D20),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          body: Column(
            children: [
              // Search Input Section
              _buildSearchInputSection(isDark, accentColor),
              
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isSearching
                      ? _buildSearchResults(filteredItems, isDark, accentColor)
                      : _buildDiscoveryHome(isDark, accentColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchInputSection(bool isDark, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141415) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1D20),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: accentColor,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _runSearch(value.trim());
            }
          },
          decoration: InputDecoration(
            hintText: 'Search products, notes, PDFs, books, links and more...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 13.5,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: accentColor,
              size: 22,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryHome(bool isDark, Color accentColor) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Recent Searches Chip Section
        if (_recentSearches.isNotEmpty) ...[
          _buildRecentSearchesPillChips(isDark, accentColor),
          const SizedBox(height: 24),
        ],

        // Discover Categories
        Text(
          'Discover Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1D20),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        _buildCategoriesGrid(isDark, accentColor),
        const SizedBox(height: 28),

        // Recently Saved By Community
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Saved By Community',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1D20),
                letterSpacing: 0.3,
              ),
            ),
            Icon(
              Icons.explore_outlined,
              color: accentColor,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSavedItemsList(_savedItems, isDark, accentColor),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRecentSearchesPillChips(bool isDark, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((search) {
            return GestureDetector(
              onTap: () => _runSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E24) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      search,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? Colors.white70 : const Color(0xFF1A1D20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeRecentSearch(search),
                      child: Icon(
                        Icons.close,
                        size: 13,
                        color: isDark ? Colors.white30 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(bool isDark, Color accentColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final category = _categories[index];
        final gradientColors = category['gradient'] as List<Color>;
        
        return GestureDetector(
          onTap: () => _runSearch(category['name']),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Visual Accent circle overlay
                Positioned(
                  right: -15,
                  bottom: -15,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavedItemsList(List<CommunitySaveItem> items, bool isDark, Color accentColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildSavedItemCard(item, isDark, accentColor);
      },
    );
  }

  Widget _buildSavedItemCard(CommunitySaveItem item, bool isDark, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141414) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Content side details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header category/type tags
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.platform,
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A1D20),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Saves count and Type Icon
                      Row(
                        children: [
                          Icon(
                            Icons.bookmark,
                            size: 14,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.saveCount,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Mini type badge indicator
                          _getTypeIcon(item.type, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Thumbnail side
              Container(
                width: 95,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                ),
                child: Image.network(
                  item.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                    child: Center(
                      child: Icon(
                        _getTypeRawIcon(item.type),
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeRawIcon(String type) {
    switch (type) {
      case 'Product':
        return Icons.shopping_bag_outlined;
      case 'Book':
        return Icons.menu_book_rounded;
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'Note':
        return Icons.sticky_note_2_rounded;
      case 'Link':
        return Icons.link_rounded;
      case 'Music':
        return Icons.audiotrack_rounded;
      default:
        return Icons.bookmark_outline;
    }
  }

  Widget _getTypeIcon(String type, bool isDark) {
    final iconData = _getTypeRawIcon(type);
    return Tooltip(
      message: type,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white12 : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: 14,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<CommunitySaveItem> results, bool isDark, Color accentColor) {
    return Column(
      children: [
        _buildFilterChips(isDark, accentColor),
        Expanded(
          child: results.isEmpty
              ? _buildNoResultsView(isDark, accentColor)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return _buildSavedItemCard(results[index], isDark, accentColor);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(bool isDark, Color accentColor) {
    final filters = ['All', 'Products', 'Notes & PDFs', 'Links & Books'];
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white 
                      : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12.5,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                }
              },
              selectedColor: accentColor,
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected 
                      ? accentColor 
                      : (isDark ? Colors.white10 : Colors.black12),
                ),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsView(bool isDark, Color accentColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No items discovered',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1D20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any saved items matching "$_searchQuery" under this filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
