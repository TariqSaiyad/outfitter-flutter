import 'package:localstorage/localstorage.dart';

import 'item.dart';
import 'outfit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable(nullable: false)
class Person {
  static final LocalStorage storage = LocalStorage('personData.json');
  final List<Item> items;
  final List<Outfit> outfits;
  Map<String, int> itemCounts = {};

  Person({this.items, this.outfits});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// Creates the person object from local storage.
  factory Person.fromStorage() {
    // get data from local storage.
    dynamic data = storage.getItem('person');
    // create the person object.
    var p =
        data == null ? Person(items: [], outfits: []) : Person.fromJson(data);
    //update the map for the item counts.
    p.updateItemCounts(p);
    return p;
  }

  void updateItemCounts(Person p) {
    p.itemCounts = {};
    p.items.forEach((element) {
      var cat = element.category.toLowerCase();
      p.itemCounts[cat] = p.itemCounts[cat] != null ? p.itemCounts[cat] + 1 : 1;
    });

    print(p.itemCounts);
  }

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  // Add item to the Person object and re-serialize and update storage.
  void addItem(Item i) {
    // add to item list.
    items.add(i);
    // update local storage.
    storage.setItem('person', toJson());
    // update the item category count.
    var cat = i.category.toLowerCase();
    itemCounts[cat] = itemCounts[cat] + 1;
//    updateItemCounts(this);
    print("item ${i.name} ADDED!");
    print(toJson());
  }

  //  void addItem(
//    String image,
//    String name,
//    String type,
//    String dressCode,
//    String color,
//    String category,
//  ) {
//    items.add(new Item(image, name, type, dressCode, color, category));
//    storage.setItem('person', this.toJson());
//  }

  /// Remove an item from Person object, re-serialise.
  /// Returns true if the item is removed successfully.
  bool removeItem(Item i) {
    if (!items.contains(i)) return false;
//    items.remove(i);
//    storage.setItem('person', this.toJson());
    print(itemCounts);
    var cat = i.category.toLowerCase();
    itemCounts[cat] = itemCounts[cat] - 1;
//    updateItemCounts(this);
    print("REMOVED");
    print(toJson());
    return true;
  }

  /// Add a new outfit to the Person object, re-serialise.
  void addOutfit(Outfit o) {
    outfits.add(o);
    storage.setItem('person', toJson());
    print("Outfit ${o.name} ADDED!");
  }

//  void addOutfit(String name, List<Item> accessories, List<Item> layers,
//      Item pants, Item shoes) {
//    outfits.add(new Outfit(name, accessories, layers, pants, shoes));
//    storage.setItem('person', this.toJson());
//  }

  /// Remove outfit from Person object, re-serialise.
  /// Returns true if the outfit is removed successfully.
  bool removeOutfit(Outfit o) {
    if (!outfits.contains(o)) return false;
    outfits.remove(o);
    storage.setItem('person', toJson());
    return true;
  }

  /// Get the number of items stored in a particular category.
  int getCategoryCount(String category) {
    return itemCounts[category] ?? 0;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
