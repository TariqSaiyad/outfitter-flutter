import 'dart:io';

import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/pages/add_item_screen.dart';
import 'package:Outfitter/pages/item_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  const GridItemWidget(
      {Key key,
      @required this.item,
      this.isGrid = true,
      this.removeItemFn,
      this.outfit,
      this.showName = true,
      this.onTap})
      : super(key: key);

  final Item item;
  final Outfit outfit;
  final Function removeItemFn;
  final bool isGrid;
  final bool showName;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    // set the hero animation key here.
    var tag =
        "${item.name}-${item.category}-${item.color}${outfit != null ? outfit.name : ""}";

    return isGrid ? buildHero(context, tag) : buildDisplay(tag, context);
  }

  Widget buildDisplay(String tag, BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                child: File(item.image).existsSync()
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings:
                                    RouteSettings(name: 'image_view_page'),
                                builder: (context) =>
                                    ImageView(file: item.image)),
                          );
                        },
                        child: Image.file(
                          File(item.image),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Hero buildHero(BuildContext context, String tag) {
    return Hero(
      tag: tag,
      child: Container(
        decoration: BoxDecoration(
            border: showName ? null : Border.all(color: item.materialColor),
            color: item.materialColor,
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: File(item.image).existsSync()
                    ? Image.file(
                        File(item.image),
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
            showName ? _titleWidget() : const SizedBox(),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: item.materialColor.withOpacity(0.5),
                  onTap: () {
                    if (onTap != null) {
                      onTap();
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(name: 'item_page'),
                          builder: (context) {
                            return ItemDetailScreen(
                                item: item, removeItemFn: removeItemFn);
                          }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                    begin: Alignment.topCenter,
//                    end: Alignment.bottomCenter,
//                    stops: [0, 0.7],
//                    colors: [Colors.transparent, item.materialColor],
//                  ),
                color: item.materialColor.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: isGrid ? 18 : 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
