import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable(nullable: false)
class Item {
  String image;
  String name;
  String type;
  String dressCode;
  String color;
  String category;

  Item(this.image, this.name, this.type, this.dressCode, this.color,
      this.category);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

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
