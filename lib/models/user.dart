class User {
  final String displayName;
  final String username;
  final String avatarUrl;
  final String joinDate;
  final String bio;

  User({
    required this.displayName,
    required this.username,
    required this.avatarUrl,
    required this.joinDate,
    required this.bio,
  });
}

// Dummy User
final currentUser = User(
  displayName: 'Alex Memoria',
  username: 'alex_memoria',
  avatarUrl: 'https://i.pravatar.cc/150?img=11',
  joinDate: 'Joined Oct 2023',
  bio: 'Product designer & content curator. Building things at Memoria.',
);
