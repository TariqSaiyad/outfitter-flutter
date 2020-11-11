import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OutfitScreen extends StatefulWidget {
  OutfitScreen({this.person});

  final Person person;

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  @override
  Widget build(BuildContext context) {
//    widget.person.outfits.forEach((element) {
//      print(element.toJson());
//    });
    List<Outfit> outfits = widget.person.outfits;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: widget.person.outfits.length == 0
            ? Center(child: Text("NO OUTFITS"))
            : ListView.builder(
                itemCount: outfits.length,
                itemExtent: MediaQuery.of(context).size.width / 2,
                itemBuilder: (context, index) {
                  return _buildOutfitTile(outfits[index]);
                }),
      ),
    );
  }

  Widget _buildOutfitTile(Outfit o) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          o.name,
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(letterSpacing: 1.4),
        ),
        Divider(
          color: Theme.of(context).accentColor,
          thickness: 1,
        ),
        Expanded(
          child: Scrollbar(
            radius: Radius.circular(24),
            thickness: 2,
            child: ListView(
//            itemExtent: MediaQuery.of(context).size.width / 3 - 4,
              scrollDirection: Axis.horizontal,
              children: [
                for (Item i in o.layers) _outfitListItem(i, o, cat: "Layers"),
                _outfitListItem(o.pants, o),
                _outfitListItem(o.shoes, o),
                for (Item i in o.accessories) _outfitListItem(i, o),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  Widget _outfitListItem(Item i, Outfit o, {String cat = ""}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: AspectRatio(
        aspectRatio: 0.9,
        child: GridItemWidget(
          item: i,
          outfit: o,
          showName: false,
        ),
      ),
    );
  }

  Widget _buildOutfit(Outfit o) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Swiper(
                controller: SwiperController(),
//            onTap: (int val) => resetIndex(),
                scale: 0.6,
                viewportFraction: 0.5,
                scrollDirection: Axis.horizontal,
//            onIndexChanged: (int val) => widget.onUpdate(val),
                itemCount: o.layers.length,
                itemBuilder: (context, index) {
                  return GridItemWidget(
                    item: o.layers[index],
                  );
                },
              ),
            ),
            Expanded(
                child: GridItemWidget(
              item: o.pants,
            )),
            Expanded(
                child: GridItemWidget(
              item: o.shoes,
            )),
            Expanded(
              child: Swiper(
                controller: SwiperController(),
                scale: 0.6,
                viewportFraction: 0.5,
                scrollDirection: Axis.horizontal,
                itemCount: o.accessories.length,
                itemBuilder: (context, index) {
                  return GridItemWidget(
                    item: o.accessories[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
