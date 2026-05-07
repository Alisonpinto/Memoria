class Post {
  final String id;
  final String username;
  final String userAvatar;
  final String caption;
  final String imageUrl;
  final int likes;
  final int views;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.views,
    required this.createdAt,
  });
}

// Dummy Posts
final List<Post> dummyPosts = [
  Post(
    id: '1',
    username: 'travel_bug',
    userAvatar: 'https://i.pravatar.cc/150?img=1',
    caption: 'Exploring the hidden gems of the mountains. #nature #adventure',
    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1000',
    likes: 1240,
    views: 5600,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Post(
    id: '2',
    username: 'minimal_art',
    userAvatar: 'https://i.pravatar.cc/150?img=5',
    caption: 'The beauty in simplicity. Minimalist interiors are my favorite.',
    imageUrl: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?q=80&w=1000',
    likes: 850,
    views: 3200,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Post(
    id: '3',
    username: 'tech_enthusiast',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    caption: 'New workspace setup is finally complete! 🚀',
    imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=1000',
    likes: 2100,
    views: 12000,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
