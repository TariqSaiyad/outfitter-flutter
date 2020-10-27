import 'item.dart';

class Outfit {
  String name;
  List<Item> accessories = new List();
  List<Item> layers = new List();
  Item pants;
  Item shoes;

  Outfit(this.name, this.accessories, this.layers, this.pants, this.shoes);

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> m = new Map();
    m['name'] = name;

    m['layers'] = layers.map((item) {
      return item.toJSON();
    }).toList();

    m['accessories'] = accessories.map((item) {
      return item.toJSON();
    }).toList();

    m['pants'] = pants.toJSON();
    m['shoes'] = shoes.toJSON();
    return m;
  }
}
