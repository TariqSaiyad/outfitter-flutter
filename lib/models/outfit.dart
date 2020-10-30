import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'outfit.g.dart';

@JsonSerializable(nullable: false)
class Outfit {
  String name;
  List<Item> accessories = new List();
  List<Item> layers = new List();
  Item pants;
  Item shoes;

  Outfit(this.name, this.accessories, this.layers, this.pants, this.shoes);

  factory Outfit.fromJson(Map<String, dynamic> json) => _$OutfitFromJson(json);

  Map<String, dynamic> toJson() => _$OutfitToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Outfit && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

//  Map<String, dynamic> toJSON() {
//    Map<String, dynamic> m = new Map();
//    m['name'] = name;
//
//    m['layers'] = layers.map((item) {
//      return item.toJSON();
//    }).toList();
//
//    m['accessories'] = accessories.map((item) {
//      return item.toJSON();
//    }).toList();
//
//    m['pants'] = pants.toJSON();
//    m['shoes'] = shoes.toJSON();
//    return m;
//  }
}
