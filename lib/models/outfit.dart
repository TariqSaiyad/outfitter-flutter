import 'package:Outfitter/constants/constants.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'outfit.g.dart';

@HiveType(typeId: 2)
class Outfit extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  HiveList<Item> accessories;
  @HiveField(2)
  HiveList<Item> layers;
  @HiveField(3)
  Item pants;
  @HiveField(4)
  Item shoes;

  Outfit(this.name, List<Item> accessories, List<Item> layers, this.pants,
      this.shoes) {
    this.accessories = HiveList(Hive.box<Item>(HiveBoxes.items));
    this.accessories.addAll(accessories);

    this.layers = HiveList(Hive.box<Item>(HiveBoxes.items));
    this.layers.addAll(layers);
  }

  // factory Outfit.fromJson(Map<String, dynamic> json) => _$OutfitFromJson(json);

  // Map<String, dynamic> toJson() => _$OutfitToJson(this);

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
