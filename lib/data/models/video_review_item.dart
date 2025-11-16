//lib/data/models/video_review_item.dart
class VideoReviewItem {
  final String id;
  final String title;
  final String authorName;
  final String location;
  final String authorAvatarUrl;
  final String thumbnailUrl;
  final String videoUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final String listingId; // ID của tin đăng gốc

  VideoReviewItem({
    required this.id,
    required this.title,
    required this.authorName,
    required this.location,
    required this.authorAvatarUrl,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.listingId,
  });
}