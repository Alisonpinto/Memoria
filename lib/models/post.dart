class Post {
  final String id;
  final String username;
  final String userAvatar;
  final bool isVerified;
  final String category;
  final String title;
  final String? linkText;
  final List<String> imageUrls;
  final String? secondaryDescription;
  int upvotes;
  int dislikeCount;
  int commentCount;
  int shareCount;
  int saveCount;
  bool isLiked;
  bool isSaved;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    this.isVerified = false,
    required this.category,
    required this.title,
    this.linkText,
    this.imageUrls = const [],
    this.secondaryDescription,
    required this.upvotes,
    this.dislikeCount = 0,
    required this.commentCount,
    required this.shareCount,
    this.saveCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
  });
}

// Dummy Posts
final List<Post> dummyPosts = [
  Post(
    id: '1',
    username: 'r/FlutterDev',
    userAvatar: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
    isVerified: true,
    category: 'Tech / Flutter development',
    title: 'Just finished building a dynamic Reddit-style feed in Flutter! 🚀 Notice the smooth carousels and dark mode accents.',
    linkText: 'github.com/flutter/flutter',
    imageUrls: [
      'https://images.unsplash.com/photo-1617042375876-a13e36732a92?q=80&w=800',
      'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=800',
      'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800',
    ],
    secondaryDescription: 'Using ListView.builder with a custom PageView for the image carousels works flawlessly. Highly recommend this pattern for social apps.',
    upvotes: 452,
    dislikeCount: 12,
    commentCount: 84,
    shareCount: 12,
    saveCount: 34,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Post(
    id: '2',
    username: 'UI/UX Inspirations',
    userAvatar: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?q=80&w=200',
    isVerified: false,
    category: 'Design / Productivity / UI inspiration',
    title: 'Minimalism isn\'t about removing things; it\'s about making the right things stand out. 🎨',
    linkText: 'dribbble.com/inspiration',
    imageUrls: [
      'https://images.unsplash.com/photo-1558655146-d09347e92766?q=80&w=800',
      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=800',
    ],
    secondaryDescription: 'The key to a premium feel is often in the subtle details: perfectly rounded corners, constrained color palettes, and deliberate whitespace.',
    upvotes: 1205,
    dislikeCount: 45,
    commentCount: 156,
    shareCount: 89,
    saveCount: 210,
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  Post(
    id: '3',
    username: 'System Design Daily',
    userAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
    isVerified: true,
    category: 'Engineering / Architecture',
    title: 'Scaling from 1 to 1 Million Users: The Architecture Journey',
    imageUrls: [],
    secondaryDescription: 'Remember to decouple your services early. A monolithic approach gets you to market fast, but microservices let you scale when you hit product-market fit.',
    upvotes: 384,
    dislikeCount: 2,
    commentCount: 42,
    shareCount: 18,
    saveCount: 75,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
