import 'package:Outfitter/widgets/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const List types = [
  {"name": "shirts & tops", "image": "shirts.jpg"},
  {"name": "hoodies", "image": "hoodies.jpg"},
  {"name": "pants", "image": "pants.jpg"},
  {"name": "shorts", "image": "shorts.jpg"},
  {"name": "jackets", "image": "shirts2.jpg"},
  {"name": "shoes", "image": "shoes.jpg"},
  {"name": "accessories", "image": "acc.jpg"},
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
//      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Outfitter"),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {})
          ],
        ),
        body: ListView.builder(
          itemCount: types.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemTile(
              index: index,
            );
          },
        ));
  }
}
