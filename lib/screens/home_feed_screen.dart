import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF141415), // Deep premium dark grey
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF7C5CFF).withOpacity(0.4), // Soft purple-indigo outline
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C5CFF).withOpacity(0.12), // Subtle futuristic glow
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              cursorColor: const Color(0xFF7C5CFF),
              decoration: const InputDecoration(
                hintText: 'Search Memoria...',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 14, letterSpacing: 0.3, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search, color: Color(0xFF7C5CFF), size: 20),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 48,
                  minHeight: 42,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: dummyPosts.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.white12,
          thickness: 1,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final post = dummyPosts[index];
          return PostCard(post: post);
        },
      ),
    );
  }
}
