import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/mock_data_service.dart';
import '../services/theme_service.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? _selectedImage;

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty || _selectedImage != null) {
      MockDataService().addComment(widget.post.id, text, _selectedImage);
      _commentController.clear();
      setState(() {
        _selectedImage = null;
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _openGallery() {
    final mockGalleryImages = [
      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=300', // abstract purple
      'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=300', // cool art
      'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=300', // anime room
      'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=300', // retro tech
      'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=300', // microchip glow
      'https://images.unsplash.com/photo-1541701494587-cb58502866ab?q=80&w=300', // fluid art
    ];

    final isDark = ThemeService().isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF141414) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Image from Gallery',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A1D20),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: isDark ? Colors.white54 : Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: mockGalleryImages.length,
                    itemBuilder: (context, index) {
                      final imageUrl = mockGalleryImages[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = imageUrl;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
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

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF1A1D20)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF1A1D20))),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Comments List
              Expanded(
                child: ListenableBuilder(
                  listenable: MockDataService(),
                  builder: (context, child) {
                    final comments = MockDataService().getCommentsForPost(widget.post.id);
                    
                    if (comments.isEmpty) {
                      return Center(
                        child: Text('No comments yet. Be the first to reply!', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
                      );
                    }
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return _buildCommentTile(comment, isDark);
                      },
                    );
                  },
                ),
              ),
              
              // Image Preview (if selected)
              if (_selectedImage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: isDark ? const Color(0xFF141414) : const Color(0xFFF1F3F5),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF997DFF), width: 1.5),
                              image: DecorationImage(
                                image: NetworkImage(_selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Comment Input Field
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 16,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141414) : Colors.white,
                  border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black12, width: 1)),
                  boxShadow: isDark ? [] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(MockDataService().user.avatarUrl),
                      backgroundColor: Colors.grey[800],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.image_outlined, color: isDark ? Colors.white70 : Colors.black87),
                      onPressed: _openGallery,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                        ),
                        child: TextField(
                          controller: _commentController,
                          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _submitComment(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF997DFF)),
                      onPressed: _submitComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentTile(Comment comment, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.userAvatar),
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeAgo(comment.createdAt),
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 14, height: 1.3),
                ),
                if (comment.imageUrl != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      comment.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 14, color: isDark ? Colors.white54 : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      comment.upvotes.toString(),
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Text('Reply', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, size: 16, color: isDark ? Colors.white38 : Colors.black38),
        ],
      ),
    );
  }
}
