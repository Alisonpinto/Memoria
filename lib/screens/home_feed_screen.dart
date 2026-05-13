import 'package:flutter/material.dart';
import '../models/post.dart';
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
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141415) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF997DFF).withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF997DFF).withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 15, fontWeight: FontWeight.w500),
                  cursorColor: const Color(0xFF997DFF),
                  decoration: InputDecoration(
                    hintText: 'Search Memoria...',
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 14, letterSpacing: 0.3, fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF997DFF), size: 20),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 42,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                  ),
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
