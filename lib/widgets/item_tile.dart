import 'package:Outfitter/constants/styles.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/widgets/circular_badge.dart';
import 'package:vibration/vibration.dart';

import '../pages/category_screen.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  final dynamic type;
  final bool isDisplay;

  const ItemTile({Key key, this.type, this.isDisplay = false})
      : super(key: key);

  const ItemTile.display({Key key, this.type, this.isDisplay = true})
      : super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  String imgPath;
  String categoryName;
  EdgeInsetsGeometry margin = EdgeInsets.symmetric(vertical: 4, horizontal: 8);
  EdgeInsetsGeometry textPadding = EdgeInsets.all(0);

  @override
  void initState() {
    super.initState();
    imgPath = 'assets/${widget.type['image']}';
    categoryName = widget.type['name'].toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    var cat = widget.type['name'];
    return Hero(
      tag: cat,
      child: AnimatedContainer(
        margin: margin,
        height: widget.isDisplay ? 60 : 90,
        duration: const Duration(milliseconds: 150),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            child: Ink.image(
              image: AssetImage(imgPath),
              fit: BoxFit.cover,
              child: InkWell(
                splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                onTap: () => _onTapCategory(context),
                onTapDown: (TapDownDetails det) => _setMarginOnFocus(2, 4),
                onTapCancel: () => _setMarginOnCancel(4, 8),
                child: Row(
                  children: [
                    widget.isDisplay
                        ? const BackButton(color: Colors.white)
                        : const SizedBox(width: 12),
                    AnimatedContainer(
                      padding: textPadding,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        categoryName,
                        style: Styles.textX(widget.isDisplay ? 20 : 24),
                      ),
                    ),
                    const Spacer(),
                    CircularBadge(
                      text: HiveHelpers.getCategoryCount(cat).toString(),
                    ),
                    const SizedBox(width: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setMarginOnFocus(double v, double h) {
    Vibration.hasVibrator().then((value) {
      if (value) {
        Vibration.vibrate(duration: 50);
      }
    });

    setState(() {
      margin = EdgeInsets.symmetric(vertical: v, horizontal: h);
      textPadding = EdgeInsets.only(left: h + 30);
    });
  }

  void _setMarginOnCancel(double v, double h) {
    setState(() {
      margin = EdgeInsets.symmetric(vertical: v, horizontal: h);
      textPadding = EdgeInsets.all(0);
    });
  }

  void _onTapCategory(BuildContext context) {
    setState(() {
      margin = EdgeInsets.symmetric(vertical: 4, horizontal: 8);
      textPadding = EdgeInsets.all(0);
    });

    if (!widget.isDisplay) {
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: 'category_page'),
          builder: (context) => CategoryScreen(
            type: widget.type,
          ),
        ),
      );
    }
  }
}
