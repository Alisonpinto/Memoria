import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../services/theme_service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;
  
  // Mock media state
  bool _hasImage = false;
  bool _hasVideo = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handlePost() {
    if (!_hasText && !_hasImage && !_hasVideo) return;
    
    List<String> images = [];
    if (_hasImage) {
      images.add('https://images.unsplash.com/photo-1617042375876-a13e36732a92?q=80&w=800');
    }
    
    MockDataService().addPost(
      "New Post", 
      "General", 
      _textController.text.trim(), 
      images
    );
    
    // Simulate posting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully!')),
    );
    
    Navigator.pop(context); // Go back after posting
  }

  void _toggleImage() {
    setState(() {
      _hasImage = !_hasImage;
      if (_hasImage) _hasVideo = false; // mutually exclusive for this mockup
    });
  }

  void _toggleVideo() {
    setState(() {
      _hasVideo = !_hasVideo;
      if (_hasVideo) _hasImage = false; // mutually exclusive for this mockup
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canPost = _hasText || _hasImage || _hasVideo;

    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        final dividerColor = isDark ? Colors.white24 : Colors.black38;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Create Post',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: canPost ? _handlePost : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF997DFF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[800],
                    disabledForegroundColor: Colors.grey[500],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(
            children: [
              // Post Editor Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _textController,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1D20), height: 1.4),
                        decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 18),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Media Preview Placeholders
                      if (_hasImage)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1617042375876-a13e36732a92?q=80&w=800'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                  onPressed: _toggleImage,
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_hasVideo)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white54),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                  onPressed: _toggleVideo,
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              // Formatting Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12, width: 1)),
                  boxShadow: isDark ? [] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ToolbarIcon(icon: Icons.image_outlined, onTap: _toggleImage, isActive: _hasImage),
                      _ToolbarIcon(icon: Icons.videocam_outlined, onTap: _toggleVideo, isActive: _hasVideo),
                      _ToolbarIcon(icon: Icons.link_outlined, onTap: () {}),
                      Container(width: 1, height: 24, color: dividerColor, margin: const EdgeInsets.symmetric(horizontal: 8)),
                      _ToolbarIcon(icon: Icons.format_bold, onTap: () {}),
                      _ToolbarIcon(icon: Icons.format_italic, onTap: () {}),
                      _ToolbarIcon(icon: Icons.format_underlined, onTap: () {}),
                      _ToolbarIcon(icon: Icons.format_list_bulleted, onTap: () {}),
                      Container(width: 1, height: 24, color: dividerColor, margin: const EdgeInsets.symmetric(horizontal: 8)),
                      _ToolbarIcon(icon: Icons.emoji_emotions_outlined, onTap: () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolbarIcon({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService().isDarkMode;
    return IconButton(
      icon: Icon(icon),
      color: isActive ? const Color(0xFF997DFF) : (isDark ? Colors.white70 : Colors.black87),
      iconSize: 24,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      onPressed: onTap,
    );
  }
}
