class NotificationModel {
  final String username;
  final String avatarUrl;
  final String action;
  final DateTime timestamp;
  bool isNew;

  NotificationModel({
    required this.username,
    required this.avatarUrl,
    required this.action,
    required this.timestamp,
    this.isNew = false,
  });
}

final List<NotificationModel> dummyNotifications = [
  NotificationModel(
    username: 'travel_bug',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    action: 'liked your post',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    isNew: true,
  ),
  NotificationModel(
    username: 'minimal_art',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    action: 'commented: "Love this!"',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isNew: true,
  ),
  NotificationModel(
    username: 'tech_enthusiast',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    action: 'started following you',
    timestamp: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  NotificationModel(
    username: 'creative_mind',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    action: 'shared your post',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
