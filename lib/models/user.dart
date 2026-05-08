class User {
  final String displayName;
  final String username;
  final String avatarUrl;
  final String joinDate;

  User({
    required this.displayName,
    required this.username,
    required this.avatarUrl,
    required this.joinDate,
  });
}

// Dummy User
final currentUser = User(
  displayName: 'Alex Memoria',
  username: 'alex_memoria',
  avatarUrl: 'https://i.pravatar.cc/150?img=11',
  joinDate: 'Joined Oct 2023',
);
