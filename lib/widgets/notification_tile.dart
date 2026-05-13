import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/theme_service.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isDark = ThemeService().isDarkMode;
        return GestureDetector(
          onTap: () {
            if (widget.notification.isNew) {
              setState(() {
                widget.notification.isNew = false;
              });
            }
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.notification.isNew
                  ? const Color(0xFF997DFF).withOpacity(0.08)
                  : Colors.transparent,
              border: widget.notification.isNew
                  ? Border.all(color: const Color(0xFF997DFF).withOpacity(0.15), width: 1)
                  : Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(widget.notification.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D20), fontSize: 14),
                      children: [
                        TextSpan(
                          text: widget.notification.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: widget.notification.action,
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.notification.isNew)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF997DFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      _formatTimestamp(widget.notification.timestamp),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }
}
