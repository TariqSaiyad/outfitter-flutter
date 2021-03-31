import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:hive/hive.dart';

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
    await Hive.openBox<Map<String, int>>(HiveBoxes.itemCounts);
  }

  /// Get the number of items stored in a particular category.
  static int getCategoryCount(String cat) {
    return Hive.box(HiveBoxes.itemCounts).get(cat, defaultValue: 0);
  }

  /// Get a list of all items
  static List<Item> getAllItems() {
    return Hive.box<Item>(HiveBoxes.items).values.toList();
  }

  /// Get a list of all outfits
  static List<Outfit> getAllOutfits() {
    return Hive.box<Outfit>(HiveBoxes.outfits).values.toList();
  }

  /// Get a list of items in a given category.
  static List<Item> getItemsInCategory(String cat) {
    return Hive.box<Item>(HiveBoxes.items)
        .values
        .where((i) => i.category.toLowerCase() == cat)
        .toList();
  }

  // Add item to the items box
  static void addItem(Item i) {
    // add to item list.
    Hive.box<Item>(HiveBoxes.items).add(i);
    // update the counts.
    updateItemCount(i.category, "ADD");
    print("item ${i.name} ADDED!");
  }

  /// Remove an item from the box.
  /// Returns true if the item is removed successfully.
  static Future<void> removeItem(Item i) async {
    updateItemCount(i.category, "DELETE");
    await i.delete();
    print("REMOVED ITEM!");
    return true;
  }

  /// Add a new outfit to the outfits box.
  static void addOutfit(Outfit o) {
    // add to outfit box.
    Hive.box<Outfit>(HiveBoxes.outfits).add(o);
    // update the counts.
    print("OUTFIT ${o.name} ADDED!");
  }

  /// Remove outfit from the box.
  /// Returns true if the outfit is removed successfully.
  static Future<bool> removeOutfit(Outfit o) async {
    await o.delete();
    print("REMOVED OUTFIT!");
    return true;
  }

  /// Update the item counts in the given category.
  static void updateItemCount(String cat, String op) {
    var countBox = Hive.box(HiveBoxes.itemCounts);
    var count = countBox.get(cat, defaultValue: 0) as int;
    // increment, decrement accordingly.
    var newValue = op == "ADD" ? count + 1 : count - 1;
    countBox.put(cat, newValue);
  }
}
