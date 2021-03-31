import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({this.type});

  final dynamic type;

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
    _getItems();
  }

  /// Filter the items for this category.
  void _getItems() {
    var cat = widget.type['name'].toString().toLowerCase();
    setState(() {
      items = HiveHelpers.getItemsInCategory(cat);
    });
  }

  /// Remove the item and display a snackbar.
  /// When the item is removed, update the item list.
  void _removeItem(Item i) {
    HiveHelpers.removeItem(i);
    globalKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('${i.name} has been removed')));

    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Container(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ItemTile.display(type: widget.type),
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
                        var i = items[index];
                        return GridItemWidget(
                            item: i, removeItemFn: _removeItem);
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
