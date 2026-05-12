import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/mock_data_service.dart';
import '../screens/comments_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentImageIndex = 0;
  bool _isDisliked = false;

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
              title: Text(widget.post.isSaved ? 'Unsave Post' : 'Save Post', style: const TextStyle(color: Colors.white)),
              onTap: () {
                MockDataService().toggleSave(widget.post.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility_off_outlined, color: Colors.white),
              title: const Text('Hide Post', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.white),
              title: const Text('Copy Link', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
              title: const Text('Report', style: TextStyle(color: Colors.redAccent)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showShareMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Share via', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareIcon(icon: Icons.copy, label: 'Copy Link', color: Colors.blue),
                _ShareIcon(icon: Icons.message, label: 'Message', color: Colors.green),
                _ShareIcon(icon: Icons.email, label: 'Email', color: Colors.redAccent),
                _ShareIcon(icon: Icons.more_horiz, label: 'More', color: Colors.grey),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.post.imageUrls.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141414), // Slightly lighter than pure black to stand out
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      padding: const EdgeInsets.only(top: 14, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.post.userAvatar),
                  backgroundColor: Colors.grey[800],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.post.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: Colors.blue, size: 14),
                      ],
                      const SizedBox(width: 6),
                      Text(
                        '• ${_getTimeAgo(widget.post.createdAt)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                  onPressed: _showMoreMenu,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Title / Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
          
          // Clickable Link
          if (widget.post.linkText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.post.linkText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7C5CFF), // Soft purple accent
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Image Carousel Container
          if (hasImages) ...[
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    itemCount: widget.post.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[900],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          widget.post.imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Image counter badge
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    top: 12,
                    right: 28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${widget.post.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Carousel Indicators
            if (widget.post.imageUrls.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.post.imageUrls.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: _currentImageIndex == index ? 16 : 6,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index 
                            ? const Color(0xFF7C5CFF) 
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              
            const SizedBox(height: 12),
          ],
          
          // Bottom Action Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Grouped Like, Dislike, Comment on the Left
                Row(
                  children: [
                    _buildActionItem(
                      icon: widget.post.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined, 
                      color: widget.post.isLiked ? const Color(0xFF7C5CFF) : Colors.grey[400]!,
                      count: widget.post.upvotes.toString(),
                      onTap: () {
                        MockDataService().toggleLike(widget.post.id);
                      }
                    ),
                    const SizedBox(width: 24),
                    _buildActionItem(
                      icon: _isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined, 
                      color: _isDisliked ? const Color(0xFF7C5CFF) : Colors.grey[400]!,
                      onTap: () {
                        setState(() {
                          _isDisliked = !_isDisliked;
                        });
                      },
                    ),
                    const SizedBox(width: 24),
                    _buildActionItem(
                      icon: Icons.chat_bubble_outline, 
                      color: Colors.grey[400]!,
                      count: widget.post.commentCount.toString(),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CommentsScreen(post: widget.post)));
                      }
                    ),
                  ],
                ),
                // Share on the Far Right
                _buildActionItem(
                  icon: Icons.shortcut_outlined, 
                  color: Colors.grey[400]!,
                  count: widget.post.shareCount.toString(),
                  onTap: _showShareMenu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    String? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 22, color: color),
          if (count != null) ...[
            const SizedBox(width: 4),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ShareIcon({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
