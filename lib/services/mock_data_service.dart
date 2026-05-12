import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  
  MockDataService._internal() {
    _posts = List.from(dummyPosts);
  }

  late List<Post> _posts;
  final User _currentUser = currentUser;
  final Map<String, List<Comment>> _comments = {};

  List<Post> get posts => _posts;
  User get user => _currentUser;

  List<Post> get savedPosts => _posts.where((p) => p.isSaved).toList();
  List<Post> get userPosts => _posts.where((p) => p.username == _currentUser.username).toList();

  void toggleLike(String postId) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      post.isLiked = !post.isLiked;
      if (post.isLiked) {
        post.upvotes++;
      } else {
        post.upvotes--;
      }
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      post.isSaved = !post.isSaved;
      if (post.isSaved) {
        post.saveCount++;
      } else {
        post.saveCount--;
      }
      notifyListeners();
    }
  }

  void addPost(String title, String category, String? content, List<String> imageUrls) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: _currentUser.username,
      userAvatar: _currentUser.avatarUrl,
      title: title,
      category: category,
      secondaryDescription: content,
      imageUrls: imageUrls,
      upvotes: 0,
      commentCount: 0,
      shareCount: 0,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  List<Comment> getCommentsForPost(String postId) {
    if (!_comments.containsKey(postId)) {
      _comments[postId] = [
        Comment(
          id: 'c1_$postId',
          postId: postId,
          username: 'flutter_fan',
          userAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
          text: 'This looks amazing! Great job.',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          upvotes: 5,
        ),
        Comment(
          id: 'c2_$postId',
          postId: postId,
          username: 'design_guru',
          userAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
          text: 'Love the smooth carousels. Could you share the code?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          upvotes: 12,
        ),
      ];
    }
    return _comments[postId]!;
  }

  void _addCommentInternal(String postId, String text, String? imageUrl) {
    if (!_comments.containsKey(postId)) {
      _comments[postId] = [];
    }
    
    _comments[postId]!.insert(0, Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      username: _currentUser.username,
      userAvatar: _currentUser.avatarUrl,
      text: text,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    ));
  }

  void addComment(String postId, String text, [String? imageUrl]) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].commentCount++;
      _addCommentInternal(postId, text, imageUrl);
      notifyListeners();
    }
  }
}
