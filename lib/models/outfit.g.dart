// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Outfit _$OutfitFromJson(Map<String, dynamic> json) {
  return Outfit(
    json['name'] as String,
    (json['accessories'] as List)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['layers'] as List)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    Item.fromJson(json['pants'] as Map<String, dynamic>),
    Item.fromJson(json['shoes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$OutfitToJson(Outfit instance) => <String, dynamic>{
      'name': instance.name,
      'accessories': instance.accessories.map((e) => e.toJson()).toList(),
      'layers': instance.layers.map((e) => e.toJson()).toList(),
      'pants': instance.pants,
      'shoes': instance.shoes,
    };
