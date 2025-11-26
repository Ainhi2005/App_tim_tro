import 'package:json_annotation/json_annotation.dart';

part 'video_review_item.g.dart';

// --- Helper Functions ---
String _parseString(dynamic value) => value?.toString() ?? '';
int _parseInt(dynamic value) => int.tryParse(value.toString()) ?? 0;
bool _parseBool(dynamic value) => value == true;

// --- FIX LỖI: Hàm này giúp đọc toàn bộ JSON gốc ---
Object? _readRoot(Map map, String key) => map;

@JsonSerializable()
class VideoReviewItem {
  // Map 'listing_id' thành id
  // Lưu ý: Nếu JSON không có video_id, nó sẽ trả về rỗng. Bạn có thể map listing_id vào đây cũng được.
  @JsonKey(name: 'video_id', fromJson: _parseString)
  final String id;

  @JsonKey(name: 'listing_id', fromJson: _parseString)
  final String listingId;

  @JsonKey(name: 'title', fromJson: _parseString)
  final String title;

  @JsonKey(name: 'landlord', fromJson: _extractAuthorName, includeToJson: false)
  final String authorName;

  @JsonKey(name: 'landlord', fromJson: _extractAvatar, includeToJson: false)
  final String authorAvatarUrl;

  // --- SỬA LỖI Ở ĐÂY ---
  // Thêm readValue: _readRoot để lấy toàn bộ JSON
  @JsonKey(readValue: _readRoot, fromJson: _extractLocationFromRoot, includeToJson: false)
  final String location;
  // --------------------

  @JsonKey(name: 'videos', fromJson: _extractVideoUrl, includeToJson: false)
  final String videoUrl;

  @JsonKey(name: 'videos', fromJson: _extractThumbnailUrl, includeToJson: false)
  final String thumbnailUrl;

  @JsonKey(name: 'like_count', fromJson: _parseInt)
  final int likeCount;

  @JsonKey(name: 'comment_count', fromJson: _parseInt)
  final int commentCount;

  @JsonKey(defaultValue: 0)
  final int shareCount;

  @JsonKey(name: 'is_liked', fromJson: _parseBool)
  final bool isLiked;

  VideoReviewItem({
    required this.id,
    required this.listingId,
    required this.title,
    required this.authorName,
    required this.location,
    required this.authorAvatarUrl,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.likeCount,
    required this.commentCount,
    this.shareCount = 0,
    this.isLiked = false,
  });

  factory VideoReviewItem.fromJson(Map<String, dynamic> json) =>
      _$VideoReviewItemFromJson(json);
  Map<String, dynamic> toJson() => _$VideoReviewItemToJson(this);

  // --- CUSTOM EXTRACTORS ---

  static String _extractAuthorName(dynamic landlord) {
    if (landlord == null) return 'Unknown';
    return landlord['full_name']?.toString() ?? 'Unknown';
  }

  static String _extractAvatar(dynamic landlord) {
    if (landlord == null) return '';
    return landlord['avatar_url']?.toString() ?? '';
  }

  static String _extractVideoUrl(dynamic videos) {
    if (videos is List && videos.isNotEmpty) {
      return videos[0]['video_url']?.toString() ?? '';
    }
    return '';
  }

  static String _extractThumbnailUrl(dynamic videos) {
    if (videos is List && videos.isNotEmpty) {
      return videos[0]['thumbnail_url']?.toString() ?? '';
    }
    return '';
  }

  // --- SỬA LỖI LOGIC HÀM NÀY ---
  // Đổi kiểu tham số thành dynamic để tránh lỗi Cast Error
  static String _extractLocationFromRoot(dynamic json) {
    // Kiểm tra xem json có phải là Map không rồi mới xử lý
    if (json is Map) {
      String district = json['district']?.toString() ?? '';
      String city = json['city']?.toString() ?? '';

      // Xử lý hiển thị đẹp: Nếu thiếu 1 trong 2 thì không hiện dấu phẩy thừa
      if (district.isEmpty) return city;
      if (city.isEmpty) return district;

      return "$district, $city";
    }
    return '';
  }
}