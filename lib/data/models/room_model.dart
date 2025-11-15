// lib/data/models/room_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

// --- CÁC HÀM HELPER ĐỂ PHÂN TÍCH JSON AN TOÀN ---

// Chuyển đổi một giá trị (có thể là null, String, int) thành int an toàn
int _parseInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

// Chuyển đổi một giá trị (có thể là null) thành String an toàn
String _parseString(dynamic value) {
  return value?.toString() ?? '';
}

// Chuyển đổi một giá trị (có thể là null, String, int, double) thành double an toàn
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  return double.tryParse(value.toString()) ?? 0.0;
}


@JsonSerializable()
class RoomModel {
  // 1. Khai báo các thuộc tính (properties) của class

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

  // 2. Constructor: Các tham số phải khớp với các thuộc tính đã khai báo
  RoomModel({
    required this.id,       // <- Thêm 'id'
    required this.title,    // <- Sửa 'name' thành 'title'
    required this.address,
    required this.price,
    required this.area,     // <- Thêm 'area'
    required this.imageUrl,
  });

  // 3. Các factory và method để làm việc với json_serializable
  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}

