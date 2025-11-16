// lib/models/video_review.dart
class VideoReview {
  final String id;
  final String title;
  final String authorName;
  final String authorAvatarUrl;
  final String location;
  final String thumbnailUrl; // Sẽ dùng cho ảnh thumbnail thật

  VideoReview({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.location,
    required this.thumbnailUrl,
  });
}