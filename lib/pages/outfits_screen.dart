import 'dart:io';

import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/widgets/custom_dialog.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class OutfitScreen extends StatefulWidget {
  OutfitScreen({this.person});

  final Person person;

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {

  void _confirmDeleteDialog(BuildContext context, Outfit o) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Are you sure?",
            content: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Confirm delete ${o.name}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  child: const Text("Cancel"),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text("DELETE"),
                  onPressed: () {
                    widget.person.removeOutfit(o);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  color: Colors.redAccent,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
//    widget.person.outfits.forEach((element) {
//      print(element.toJson());
//    });

    return SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: widget.person.outfits.length == 0
              ? Center(child: Text("NO OUTFITS"))
              : Scrollbar(
                  radius: const Radius.circular(8),
                  thickness: 4,
                  child: ListView(
                    itemExtent: (MediaQuery.of(context).size.width / 2) + 8,
                    children: [
                      for (Outfit o in widget.person.outfits)
                        _buildOutfitTile(o),
                      const SizedBox(height: 10)
                    ],
                  ),
                )),
    );
  }

  Widget _buildOutfitTile(Outfit o) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              o.name,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(letterSpacing: 1.4),
            ),
            InkWell(
              onTap: () {
                _confirmDeleteDialog(context, o);
              },
              splashColor: Colors.white,
              child: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
        Divider(
          color: Theme.of(context).accentColor,
          thickness: 1,
          height: 12,
        ),

        Expanded(
          child: Row(children: [
            // Main clothing layer
            _outfitListItem(o.layers.first, o),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        //Secondary clothing layer if there is one.
                        o.layers.length > 1
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: _outfitListItem(o.layers[1], o),
                              ))
                            : const SizedBox(),
                        // Display pants
                        Expanded(child: _outfitListItem(o.pants, o))
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Row(
                      children: [
                        // Display single accessory if there is one.
                        o.accessories.length > 0
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: _outfitListItem(o.accessories.first, o),
                              ))
                            : const SizedBox(),
                        // Display shoes.
                        Expanded(child: _outfitListItem(o.shoes, o)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
//        Expanded(
//          child: Scrollbar(
//            radius: Radius.circular(24),
//            thickness: 2,
//            child: ListView(
////            itemExtent: MediaQuery.of(context).size.width / 3 - 4,
//              scrollDirection: Axis.horizontal,
//              children: [
//                for (Item i in o.layers) _outfitListItem(i, o, cat: "Layers"),
//                _outfitListItem(o.pants, o),
//                _outfitListItem(o.shoes, o),
//                for (Item i in o.accessories) _outfitListItem(i, o),
//              ],
//            ),
//          ),
//        ),
        const SizedBox(height: 12)
      ],
    );
  }

  Widget _outfitListItem(Item i, Outfit o) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridItemWidget(
        item: i,
        outfit: o,
        showName: false,
      ),
    );
  }

//  Widget _buildOutfit(Outfit o) {
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//      child: Container(
//        child: Column(
//          children: [
//            Expanded(
//              child: Swiper(
//                controller: SwiperController(),
////            onTap: (int val) => resetIndex(),
//                scale: 0.6,
//                viewportFraction: 0.5,
//                scrollDirection: Axis.horizontal,
////            onIndexChanged: (int val) => widget.onUpdate(val),
//                itemCount: o.layers.length,
//                itemBuilder: (context, index) {
//                  return GridItemWidget(
//                    item: o.layers[index],
//                  );
//                },
//              ),
//            ),
//            Expanded(
//                child: GridItemWidget(
//              item: o.pants,
//            )),
//            Expanded(
//                child: GridItemWidget(
//              item: o.shoes,
//            )),
//            Expanded(
//              child: Swiper(
//                controller: SwiperController(),
//                scale: 0.6,
//                viewportFraction: 0.5,
//                scrollDirection: Axis.horizontal,
//                itemCount: o.accessories.length,
//                itemBuilder: (context, index) {
//                  return GridItemWidget(
//                    item: o.accessories[index],
//                  );
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
}
