import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';
import '../models/saved_item.dart';

class MockDataService extends ChangeNotifier {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  
  MockDataService._internal() {
    _posts = List.from(dummyPosts);
    _savedItems = [
      SavedItem(
        id: 's1',
        title: 'Memoria Design System V2.pdf',
        content: 'Memoria mobile layout specs and component guidelines.',
        type: SavedItemType.pdf,
        dateSaved: DateTime.now().subtract(const Duration(days: 1)),
        isPrivate: false,
      ),
      SavedItem(
        id: 's2',
        title: 'Premium Moodboard Inspiration',
        content: 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=600',
        type: SavedItemType.image,
        thumbnailUrl: 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=600',
        dateSaved: DateTime.now().subtract(const Duration(days: 3)),
        isPrivate: false,
      ),
      SavedItem(
        id: 's3',
        title: 'Flutter State Management Guidelines',
        content: 'Use ListenableBuilder for basic reactive widgets and keep model references decoupled from widgets.',
        type: SavedItemType.note,
        dateSaved: DateTime.now().subtract(const Duration(days: 4)),
        isPrivate: true,
      ),
      SavedItem(
        id: 's4',
        title: 'Memoria Pitch Video (Draft)',
        content: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?q=80&w=400',
        type: SavedItemType.video,
        thumbnailUrl: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?q=80&w=400',
        dateSaved: DateTime.now().subtract(const Duration(days: 6)),
        isPrivate: false,
      ),
      SavedItem(
        id: 's5',
        title: 'Figma Community - iOS 17 UI kit',
        content: 'https://figma.com/@ios17-kit',
        type: SavedItemType.link,
        dateSaved: DateTime.now().subtract(const Duration(days: 8)),
        isPrivate: false,
      ),
      SavedItem(
        id: 's6',
        title: 'Focus Music - Alpha Waves Lofi',
        content: 'https://music.apple.com/focus-alpha-lofi',
        type: SavedItemType.audio,
        dateSaved: DateTime.now().subtract(const Duration(days: 10)),
        isPrivate: false,
      ),
      SavedItem(
        id: 's7',
        title: 'Startup Financial Model Sheets',
        content: 'Excel sheet template showing projected user growth and revenue margins over the next 5 years.',
        type: SavedItemType.document,
        dateSaved: DateTime.now().subtract(const Duration(days: 12)),
        isPrivate: true,
      ),
      SavedItem(
        id: 's8',
        title: 'Dark Theme Color Gradients Spec',
        content: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400',
        type: SavedItemType.image,
        thumbnailUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=400',
        dateSaved: DateTime.now().subtract(const Duration(days: 14)),
        isPrivate: false,
      ),
    ];
  }

  late List<Post> _posts;
  late List<SavedItem> _savedItems;
  final User _currentUser = currentUser;
  final Map<String, List<Comment>> _comments = {};

  List<Post> get posts => _posts;
  List<SavedItem> get savedItems => _savedItems;
  User get user => _currentUser;

  List<Post> get savedPosts => _posts.where((p) => p.isSaved).toList();
  List<Post> get userPosts => _posts.where((p) => p.username == _currentUser.username).toList();

  void addSavedItem(String title, String content, SavedItemType type, bool isPrivate, {String? thumbnailUrl}) {
    final newItem = SavedItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      type: type,
      dateSaved: DateTime.now(),
      isPrivate: isPrivate,
      thumbnailUrl: thumbnailUrl,
    );
    _savedItems.insert(0, newItem);
    notifyListeners();
  }

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
