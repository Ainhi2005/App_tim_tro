// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: _parseInt(json['listing_id']),
      title: _parseString(json['title']),
      address: _parseString(json['address']),
      price: _parseDouble(json['price']),
      area: _parseDouble(json['area']),
      imageUrl: _parseString(json['image_url']),
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'listing_id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'price': instance.price,
      'area': instance.area,
      'image_url': instance.imageUrl,
    };

HomeRoomData _$HomeRoomDataFromJson(Map<String, dynamic> json) => HomeRoomData(
      exploreRooms: (json['explore_rooms'] as List<dynamic>)
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredRooms: (json['featured_rooms'] as List<dynamic>)
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$HomeRoomDataToJson(HomeRoomData instance) =>
    <String, dynamic>{
      'explore_rooms': instance.exploreRooms,
      'featured_rooms': instance.featuredRooms,
      'total': instance.total,
    };

HomeRoomResponse _$HomeRoomResponseFromJson(Map<String, dynamic> json) =>
    HomeRoomResponse(
      status: json['status'] as String,
      data: HomeRoomData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeRoomResponseToJson(HomeRoomResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
