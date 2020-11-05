import 'dart:io';

import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/pages/item_detail_screen.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({this.type, this.person});

  final dynamic type;
  final Person person;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Item> items;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.type['name']);
    getItems();
  }

  void getItems() {
    setState(() {
      items = widget.person.items
          .where((element) =>
              element.category.toLowerCase() ==
              widget.type['name'].toString().toLowerCase())
          .toList();
    });
  }

  void removeItem(Item i) {
    widget.person.removeItem(i);
    globalKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('${i.name} has been removed')));

    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Container(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ItemTile.display(person: widget.person, type: widget.type),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        Item i = items[index];
                        return GridItemWidget(
                            item: i, removeItemFn: removeItem);
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
