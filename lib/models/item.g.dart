// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    json['image'] as String,
    json['name'] as String,
    json['type'] as String,
    json['dressCode'] as String,
    json['color'] as String,
    json['category'] as String,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'type': instance.type,
      'dressCode': instance.dressCode,
      'color': instance.color,
      'category': instance.category,
    };
