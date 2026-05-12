class Comment {
  final String id;
  final String postId;
  final String username;
  final String userAvatar;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  int upvotes;

  Comment({
    required this.id,
    required this.postId,
    required this.username,
    required this.userAvatar,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    this.upvotes = 0,
  });
}
