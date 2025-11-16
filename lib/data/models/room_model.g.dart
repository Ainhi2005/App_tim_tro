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
