import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:flutter/material.dart';

import 'grid_item_widget.dart';
import 'selectable_container.dart';

class SelectionWidget extends StatefulWidget {
  final List<Item> items;
  final List<String> list;
  final Function onTap;
  final Function test;
  final bool withAppbar;

  const SelectionWidget(
      {Key key,
      this.items,
      this.list,
      this.onTap,
      this.test,
      this.withAppbar = true})
      : super(key: key);

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  Map<String, List<Item>> catToItems = {};

  @override
  void initState() {
    super.initState();
    for (var cat in widget.list) {
      var tmp = HiveHelpers.getItemsInCategory(cat);
      catToItems[cat] = tmp;
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    var count = 0;
    for (var cat in catToItems.keys.toList()) {
      var tmp = catToItems[cat];
      if (tmp.isEmpty) continue;

      if (widget.withAppbar) {
        widgetList
          .add(SliverAppBar(
            toolbarHeight: kToolbarHeight * 0.8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(count % 2 == 0 ? 8 : 0),
              topRight: Radius.circular(count % 2 == 0 ? 8 : 0),
              bottomLeft: Radius.circular(count % 2 == 0 ? 0 : 8),
              bottomRight: Radius.circular(count % 2 == 0 ? 0 : 8),
            )),
            automaticallyImplyLeading: false,
            title: Text(cat, style: TextStyle(letterSpacing: 1.5)),
            pinned: true,
          ));
      }

      widgetList.add(SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: SelectableContainer(
                  selectedBorderColor: tmp[index].materialColor,
                  selected: widget.test(tmp[index]),
                  onPressed: () {},
                  child: GridItemWidget(
                      item: tmp[index],
                      onTap: () {
                        widget.onTap(tmp[index]);
//                          addOrRemoveLayer(tmp[index]);
                      })),
            );
          }, childCount: tmp.length)));
      count++;
    }

    return CustomScrollView(
      slivers: widgetList,
    );
  }
}
