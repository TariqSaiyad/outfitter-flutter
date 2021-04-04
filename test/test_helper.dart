import 'dart:math';

import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:random_string/random_string.dart';

class TestHelper {
  static int count = 0;

  /// Creates a random outfit from some random Items
  static Future<Outfit> generateOutfit() async {
    var ac = await generateItem(Categories.ACCESSORIES);
    var l1 = await generateItem(Categories.HOODIES);
    var l2 = await generateItem(Categories.SHIRTS);
    var p = await generateItem(Categories.PANTS);
    var s = await generateItem(Categories.SHOES);

    var o = Outfit(randomString(5), <Item>[ac], <Item>[l1, l2], p, s);
    HiveHelpers.addOutfit(o);
    // print(o.toJSON());
    return o;
  }

  /// Generates an item from randomly generated strings
  static Future<Item> generateItem(String cat) async {
    var type = CLOTHING_TYPES[Random().nextInt(CLOTHING_TYPES.length)];
    var code = DRESS_CODES[Random().nextInt(DRESS_CODES.length)];
    var col = COLORS_LIST.keys.toList()[Random().nextInt(COLORS_LIST.length)];
    var i = Item(randomAlpha(2), randomAlpha(5), type, code, col, cat);
    // print(i.toJson());
    await HiveHelpers.addItem(i);
    return i;
  }
}
