// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    items: (json['items'] as List)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
    outfits: (json['outfits'] as List)
        .map((e) => Outfit.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'outfits': instance.outfits.map((e) => e.toJson()).toList(),
    };
