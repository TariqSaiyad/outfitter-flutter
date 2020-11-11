import 'package:flutter/material.dart';

//const String SHIRTS ="Shirts";
//const String HOODIES ="Hoodies";
//const String SHIRTS ="Jackets";
//const String SHIRTS ="Pants";

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
  "Shirts",
  "Hoodies",
  "Jackets",
  "Pants",
  "Shorts",
  "Shoes",
  "Accessories",
];

const List<String> LAYERS_LIST = [
  "Shirts",
  "Hoodies",
  "Jackets",
];
const List<String> LEGWEAR_LIST = [
  "Pants",
  "Shorts",
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

const List DRESS_CODES = ["Streetwear", "Casual", "Business Casual", "Formal"];
const List CLOTHING_TYPES = ["Warm", "Cool", "Neutral", "Weatherproof"];

const int MAX_ACCESSORIES = 4;
const int MAX_LAYERS = 2;
