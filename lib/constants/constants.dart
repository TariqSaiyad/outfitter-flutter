import 'package:flutter/material.dart';

//const String SHIRTS ="Shirts";
//const String HOODIES ="Hoodies";
//const String SHIRTS ="Jackets";
//const String SHIRTS ="Pants";

class Categories {
  static const String SHIRTS = "Shirts";
  static const String HOODIES = "Hoodies";
  static const String JACKETS = "Jackets";
  static const String PANTS = "Pants";
  static const String SHORTS = "Shorts";
  static const String SHOES = "Shoes";
  static const String ACCESSORIES = "Accessories";
}

const List TYPES = [
  {"name": "shirts", "image": "shirts.jpg"},
  {"name": "hoodies", "image": "hoodies.jpg"},
  {"name": "jackets", "image": "shirts2.jpg"},
  {"name": "pants", "image": "pants.jpg"},
  {"name": "shorts", "image": "shorts.jpg"},
  {"name": "shoes", "image": "shoes.jpg"},
  {"name": "accessories", "image": "acc.jpg"},
];

const List<String> CATEGORY_LIST = [
  Categories.SHIRTS,
  Categories.HOODIES,
  Categories.JACKETS,
  Categories.PANTS,
  Categories.SHORTS,
  Categories.SHOES,
  Categories.ACCESSORIES,
];

const List<String> LAYERS_LIST = [
  Categories.SHIRTS,
  Categories.HOODIES,
  Categories.JACKETS,
];
const List<String> LEGWEAR_LIST = [
  Categories.PANTS,
  Categories.SHORTS,
];

const Map<String, Color> COLORS_LIST = {
  "red": Colors.red,
  "pink": Colors.pink,
  "purple": Colors.purple,
  "blue": Colors.blue,
  "green": Colors.green,
  "yellow": Colors.yellow,
  "orange": Colors.orange,
  "brown": Colors.brown,
  "grey": Colors.grey,
  "black": Colors.black,
  "white": Colors.white
};

const Map<int, String> SCREEN_MAP = {
  0: "add_item_page",
  1: "home_page",
  2: "outfit_page"
};

const List DRESS_CODES = ["Streetwear", "Casual", "Business Casual", "Formal"];
const List CLOTHING_TYPES = ["Warm", "Cool", "Neutral", "Weatherproof"];

const int MAX_ACCESSORIES = 4;
const int MAX_LAYERS = 2;

const FEATURES = [
  'first_id',
];

class HiveBoxes {
  HiveBoxes._();

  //FIXME: needs to be fixed
  static const String items = 'favorites';
  static const String outfits = 'searches';
  static const String itemCounts = 'itemCounts';
}
