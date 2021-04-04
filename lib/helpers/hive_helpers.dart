import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:hive/hive.dart';

/// Collection of methods for retrieving and performing various operations on Hive objects.
/// Items, Outfits and a Map of the Category -> Item count are stored in Hive boxes.
class HiveHelpers {
  HiveHelpers._();

  // Register the adapters for the types we want to use.
  static void registerAdapters() {
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(OutfitAdapter());
  }

  //Open the items and outfits boxes
  static Future<void> openBoxes() async {
    //open boxes
    await Hive.openBox<Item>(HiveBoxes.items);
    await Hive.openBox<Outfit>(HiveBoxes.outfits);
    await Hive.openBox(HiveBoxes.itemCounts);
  }

  static Future<void> deleteAll() async {
    print("DELETING ALL BOXES....");
    // Hive.box<Item>(HiveBoxes.items).values.map((e) {
    //   print('Deleting ${e.name}');
    //   e.delete();
    // });
    // Hive.box<Outfit>(HiveBoxes.outfits).values.map((e) {
    //   print('Deleting ${e.name}');
    //   e.delete();
    // });
    await Hive.box<Outfit>(HiveBoxes.outfits).clear();
    await Hive.box<Item>(HiveBoxes.items).clear();
    await Hive.box(HiveBoxes.itemCounts).clear();
    // await Hive.deleteFromDisk();
    // await Hive.deleteFromDisk();
  }

  /// Get the number of items stored in a particular category.
  static int getCategoryCount(String cat) {
    if (!Hive.isBoxOpen(HiveBoxes.itemCounts)) {
      return -1;
    }
    return Hive.box(HiveBoxes.itemCounts)
        .get(cat.toLowerCase(), defaultValue: 0);
  }

  /// Get a list of all items
  static List<Item> getAllItems() {
    var items = Hive.box<Item>(HiveBoxes.items).values.toList();
    print('Total items: ${items.length}\n\n');
    // items.map((e) => print(e.toJson()));
    for (var o in items) {
      print(o.toJson());
    }
    return items;
  }

  /// Get a list of all outfits
  static List<Outfit> getAllOutfits() {
    if (!Hive.isBoxOpen(HiveBoxes.outfits)) {
      return <Outfit>[];
    }
    var start = DateTime.now();
    var outfits = Hive.box<Outfit>(HiveBoxes.outfits).values.toList();
    var end = DateTime.now();
    print('Time to get all outfits : ${end.difference(start).inMilliseconds}');
    print('Total outfits : ${outfits.length}');
    return outfits;
  }

  /// Get a list of items in a given category.
  static List<Item> getItemsInCategory(String cat) {
    var box = Hive.box<Item>(HiveBoxes.items);
    return box.values
        .where((i) => i.category.toLowerCase() == cat.toLowerCase())
        .toList();
  }

  /// Add item to the items box and update item count map.
  static Future<void> addItem(Item i) async {
    await Hive.box<Item>(HiveBoxes.items).add(i);
    updateItemCount(i.category, "ADD");
    // print("item ${i.name} ADDED!");
  }

  /// Remove an item from the box.
  /// Returns true if the item is removed successfully.
  static Future<bool> removeItem(Item i) async {
    var cat = i.category;
    return await i.delete().then((value) {
      updateItemCount(cat, "DELETE");
      print("REMOVED ITEM!");
      return true;
    }, onError: (err) {
      print(err);
      return false;
    });
  }

  /// Add a new outfit to the outfits box.
  static void addOutfit(Outfit o) {
    Hive.box<Outfit>(HiveBoxes.outfits).add(o);
    print("OUTFIT ${o.name} ADDED!");
  }

  /// Remove outfit from the box.
  /// Returns true if the outfit is removed successfully.
  static Future<bool> removeOutfit(Outfit o) async {
    return await o.delete().then((value) {
      print("REMOVED OUTFIT!");
      return true;
    }, onError: (err) {
      print(err);
      return false;
    });
  }

  /// Update the item counts in the given category.
  static void updateItemCount(String cat, String op) {
    var countBox = Hive.box(HiveBoxes.itemCounts);
    var count = countBox.get(cat.toLowerCase(), defaultValue: 0) as int;
    // increment, decrement accordingly.
    var newValue = op == "ADD" ? ++count : --count;
    // print('Adding $newValue - ${cat.toLowerCase()}');
    countBox.put(cat.toLowerCase(), newValue);
  }
}
