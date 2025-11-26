import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  @JsonKey(name: 'comment_id')
  final int id;

  @JsonKey(name: 'content')
  final String content;

  // --- SỬA Ở ĐÂY: Thêm includeToJson: false ---
  @JsonKey(name: 'user', fromJson: _extractUserName, includeToJson: false)
  final String userName;

  // --- SỬA Ở ĐÂY: Thêm includeToJson: false ---
  @JsonKey(name: 'user', fromJson: _extractUserAvatar, includeToJson: false)
  final String userAvatar;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  // Thêm rating nếu muốn hiển thị (Backend đã hỗ trợ)
  @JsonKey(name: 'rating')
  final int? rating;

  CommentModel({
    required this.id,
    required this.content,
    required this.userName,
    required this.userAvatar,
    required this.timestamp,
    this.rating,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  // Helper để lấy tên và avatar từ object user lồng bên trong
  static String _extractUserName(dynamic user) {
    if (user == null) return 'Unknown';
    return user['full_name']?.toString() ?? 'Unknown';
  }

  static String _extractUserAvatar(dynamic user) {
    if (user == null) return '';
    return user['avatar_url']?.toString() ?? '';
  }
}