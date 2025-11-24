// lib/data/models/room_model.dart (Bản Gộp)

import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart'; // File .g.dart sẽ chứa code cho cả 3 class

// --- CÁC HÀM HELPER ĐỂ PHÂN TÍCH JSON AN TOÀN ---

int _parseInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}
String _parseString(dynamic value) {
  return value?.toString() ?? '';
}
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}

// =======================================================
// 1. CORE ENTITY MODEL (RoomModel - Giữ nguyên)
// =======================================================

@JsonSerializable()
class RoomModel {
  @JsonKey(name: 'listing_id', fromJson: _parseInt)
  final int id;

  @JsonKey(fromJson: _parseString)
  final String title;

  @JsonKey(fromJson: _parseString)
  final String address;

  @JsonKey(fromJson: _parseDouble)
  final double price;

  @JsonKey(name: 'area', fromJson: _parseDouble)
  final double area;

  @JsonKey(name: 'image_url', fromJson: _parseString)
  final String imageUrl;

  RoomModel({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.area,
    required this.imageUrl,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}

// =======================================================
// 2. RESPONSE DATA MODEL (HomeRoomData - Lớp lồng cho trường 'data')
// =======================================================

@JsonSerializable()
class HomeRoomData {
  @JsonKey(name: 'explore_rooms')
  final List<RoomModel> exploreRooms;

  @JsonKey(name: 'featured_rooms')
  final List<RoomModel> featuredRooms;

  final int total;

  HomeRoomData({
    required this.exploreRooms,
    required this.featuredRooms,
    required this.total,
  });

  factory HomeRoomData.fromJson(Map<String, dynamic> json) => _$HomeRoomDataFromJson(json);
  Map<String, dynamic> toJson() => _$HomeRoomDataToJson(this);
}

// =======================================================
// 3. API RESPONSE WRAPPER (HomeRoomResponse - Lớp ngoài)
// =======================================================

@JsonSerializable()
class HomeRoomResponse {
  final String status;

  @JsonKey(name: 'data')
  final HomeRoomData data;

  HomeRoomResponse({
    required this.status,
    required this.data,
  });

  factory HomeRoomResponse.fromJson(Map<String, dynamic> json) => _$HomeRoomResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HomeRoomResponseToJson(this);
}