class Post {
  final String id;
  final String username;
  final String userAvatar;
  final String title;
  final String? linkText;
  final String? imageUrl;
  final int upvotes;
  final int commentCount;
  final int shareCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.title,
    this.linkText,
    this.imageUrl,
    required this.upvotes,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
  });
}

// Dummy Posts
final List<Post> dummyPosts = [
  Post(
    id: '1',
    username: 'r/FlutterDev',
    userAvatar: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
    title: 'Just finished building a dynamic Reddit-style feed in Flutter! 🚀',
    linkText: 'github.com/flutter/flutter',
    imageUrl: 'https://images.unsplash.com/photo-1617042375876-a13e36732a92?q=80&w=800',
    upvotes: 452,
    commentCount: 84,
    shareCount: 12,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
];
