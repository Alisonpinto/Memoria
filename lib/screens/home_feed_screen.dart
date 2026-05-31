import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../services/mock_data_service.dart';
import '../services/theme_service.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF1A1D20), size: 26),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'What are you searching for today..',
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF1A1D20),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          body: ListenableBuilder(
            listenable: MockDataService(),
            builder: (context, child) {
              final posts = MockDataService().posts;
              return RefreshIndicator(
                color: const Color(0xFF997DFF),
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(post: post);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
