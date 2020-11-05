import 'dart:io';

import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/pages/item_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridItemWidget extends StatelessWidget {
  const GridItemWidget(
      {Key key, @required this.item, this.isGrid = true, this.removeItemFn})
      : super(key: key);

  final Item item;
  final Function removeItemFn;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return isGrid ? buildHero(context) : buildDisplay(context);
  }

  Widget buildDisplay(BuildContext context) {
    return Hero(
      tag: "${item.name}-${item.category}-${item.color}",
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                child: Image.file(
                  File(item.image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
//            Positioned.fill(
//              child: Align(
//                alignment: Alignment.topLeft,
//                child: Material(
//                  color: Colors.transparent,
//                  child: Row(
//                    children: [BackButton()],
//                  ),
//                ),
//              ),
//            )
//            _titleWidget(),
          ],
        ),
      ),
    );
  }

  Hero buildHero(BuildContext context) {
    return Hero(
      tag: "${item.name}-${item.category}-${item.color}",
      child: Container(
        decoration: BoxDecoration(
            color: item.materialColor, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Image.file(
                  File(item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _titleWidget(),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: item.materialColor.withOpacity(0.5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ItemDetailScreen(item: item, removeItemFn:removeItemFn);
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
