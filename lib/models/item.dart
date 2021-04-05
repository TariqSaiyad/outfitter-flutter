import 'package:Outfitter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item extends HiveObject {
  @HiveField(0)
  String image;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String dressCode;
  @HiveField(4)
  String color;
  @HiveField(5)
  String category;

  Item(this.image, this.name, this.type, this.dressCode, this.color,
      this.category);

  // factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'type': type,
      'dressCode': dressCode,
      'color': color,
      'category': category
    };
  }

  /// Get the material Color object from the string representation of the item color.
  Color get materialColor => COLORS_LIST[color];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          dressCode == other.dressCode &&
          color == other.color &&
          category == other.category;

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      dressCode.hashCode ^
      color.hashCode ^
      category.hashCode;
}
