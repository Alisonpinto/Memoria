import 'package:flutter/material.dart';

enum SavedItemType {
  pdf,
  image,
  video,
  link,
  audio,
  note,
  document,
}

extension SavedItemTypeExtension on SavedItemType {
  String get label {
    switch (this) {
      case SavedItemType.pdf:
        return 'PDF';
      case SavedItemType.image:
        return 'Image';
      case SavedItemType.video:
        return 'Video';
      case SavedItemType.link:
        return 'Link';
      case SavedItemType.audio:
        return 'Audio';
      case SavedItemType.note:
        return 'Note';
      case SavedItemType.document:
        return 'Document';
    }
  }

  IconData get icon {
    switch (this) {
      case SavedItemType.pdf:
        return Icons.picture_as_pdf_outlined;
      case SavedItemType.image:
        return Icons.image_outlined;
      case SavedItemType.video:
        return Icons.play_circle_outline;
      case SavedItemType.link:
        return Icons.link_outlined;
      case SavedItemType.audio:
        return Icons.audiotrack_outlined;
      case SavedItemType.note:
        return Icons.sticky_note_2_outlined;
      case SavedItemType.document:
        return Icons.text_snippet_outlined;
    }
  }

  Color get color {
    switch (this) {
      case SavedItemType.pdf:
        return const Color(0xFFFF453A); // Bright Red
      case SavedItemType.image:
        return const Color(0xFF64D2FF); // Bright Blue
      case SavedItemType.video:
        return const Color(0xFFFF375F); // Pink/Red
      case SavedItemType.link:
        return const Color(0xFF30D158); // Green
      case SavedItemType.audio:
        return const Color(0xFFBF5AF2); // Purple
      case SavedItemType.note:
        return const Color(0xFFFFD60A); // Yellow
      case SavedItemType.document:
        return const Color(0xFF5E5CE6); // Indigo
    }
  }
}

class SavedItem {
  final String id;
  final String title;
  final String content;
  final SavedItemType type;
  final DateTime dateSaved;
  final bool isPrivate;
  final String? thumbnailUrl;

  SavedItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.dateSaved,
    this.isPrivate = false,
    this.thumbnailUrl,
  });
}
