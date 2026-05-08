import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F0F),
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(post.userAvatar),
                  backgroundColor: Colors.grey[800],
                ),
                const SizedBox(width: 8),
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '• ${_getTimeAgo(post.createdAt)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.grey, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              post.title,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
          if (post.linkText != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                post.linkText!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7C5CFF),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          // Image
          if (post.imageUrl != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[900],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[900],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Interaction Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Upvote and Downvote Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_upward, size: 18, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        post.upvotes.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 14,
                        color: Colors.white24,
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_downward, size: 18, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Comment Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        post.commentCount.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Share Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shortcut, size: 20, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        post.shareCount.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
