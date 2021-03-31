import 'package:Outfitter/helpers/hive_helpers.dart';

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
  String itemCount;
  String imgPath;
  String categoryName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemCount = HiveHelpers.getCategoryCount(widget.type['name']).toString();
    imgPath = 'assets/${widget.type['image']}';
    categoryName = widget.type['name'].toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.type['name'],
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          height: widget.isDisplay ? 60 : 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              child: Ink.image(
                image: AssetImage(imgPath),
                fit: BoxFit.cover,
                child: InkWell(
                  splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                  onTap: () => _onTapCategory(context),
                  child: Row(
                    children: [
                      widget.isDisplay
                          ? const BackButton(color: Colors.white)
                          : const SizedBox(width: 12),
                      Text(
                        categoryName,
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w400,
                            fontSize: widget.isDisplay ? 20 : 24),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.6),
                        radius: 16,
                        child: Text(itemCount,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: widget.isDisplay ? 18 : 20)),
                      ),
                      const SizedBox(width: 12)
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void _onTapCategory(BuildContext context) {
    if (!widget.isDisplay) {
      Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(name: 'category_page'),
            builder: (context) => CategoryScreen(
                  type: widget.type,
                )),
      );
    }
  }
}
