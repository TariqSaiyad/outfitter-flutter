import 'package:localstorage/localstorage.dart';

import 'item.dart';
import 'outfit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(nullable: false)
class Person {
  static final LocalStorage storage = new LocalStorage('person');

  final List<Item> items;
  final List<Outfit> outfits;

  Person({this.items, this.outfits});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// Creates the person object from local storage.
  factory Person.fromStorage() => storage.getItem('person') == null
      ? Person(items: new List(), outfits: new List())
      : Person.fromJson(storage.getItem('person'));

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  // Add item to the Person object and re-serialize and update storage.
  void addItem(
    String image,
    String name,
    String type,
    String dressCode,
    String color,
    String category,
  ) {
    items.add(new Item(image, name, type, dressCode, color, category));
    storage.setItem('person', this.toJson());
  }

  /// Remove an item from Person object, re-serialise.
  /// Returns true if the item is removed successfully.
  bool removeItem(Item i) {
    if (!items.contains(i)) return false;
    items.remove(i);
    storage.setItem('person', this.toJson());
    return true;
  }

  /// Add a new outfit to the Person object, re-serialise.
  void addOutfit(String name, List<Item> accessories, List<Item> layers,
      Item pants, Item shoes) {
    outfits.add(new Outfit(name, accessories, layers, pants, shoes));
    storage.setItem('person', this.toJson());
  }

  /// Remove outfit from Person object, re-serialise.
  /// Returns true if the outfit is removed successfully.
  bool removeOutfit(Outfit o) {
    if (!outfits.contains(o)) return false;
    outfits.remove(o);
    storage.setItem('person', this.toJson());
    return true;
  }

  String toString() {
    return this.toJson().toString();
  }
}
