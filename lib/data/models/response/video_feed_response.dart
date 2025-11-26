import 'package:json_annotation/json_annotation.dart';
import '../video_review_item.dart';

part 'video_feed_response.g.dart';

@JsonSerializable()
class VideoFeedResponse {
  final String status;

  @JsonKey(name: 'data')
  final List<VideoReviewItem> data;

  VideoFeedResponse({
    required this.status,
    required this.data,
  });

  factory VideoFeedResponse.fromJson(Map<String, dynamic> json) => _$VideoFeedResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VideoFeedResponseToJson(this);
}