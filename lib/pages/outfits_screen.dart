import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/widgets/custom_dialog.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class OutfitScreen extends StatefulWidget {
  OutfitScreen({this.person, this.isAltOutfitView});

  final Person person;
  final bool isAltOutfitView;

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  void onRemove(Outfit o) {
    widget.person.removeOutfit(o);
    setState(() {});
    Navigator.pop(context);
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
              ? const Center(child: Text("NO OUTFITS"))
              : Scrollbar(
                  radius: const Radius.circular(8),
                  thickness: 4,
                  child: ListView(
                    itemExtent: (MediaQuery.of(context).size.width / 2) + 8,
                    children: [
                      for (Outfit o in widget.person.outfits)
                        OutfitTile(
                            o: o,
                            onRemove: onRemove,
                            altView: widget.isAltOutfitView),
//                        _buildOutfitTile(o),
                      const SizedBox(height: 10)
                    ],
                  ),
                )),
    );
  }
}

class OutfitTile extends StatelessWidget {
  final Outfit o;
  final Function onRemove;
  final bool altView;

  const OutfitTile({Key key, this.o, this.onRemove, this.altView})
      : super(key: key);

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
                  onPressed: () => onRemove(o),
                  color: Colors.redAccent,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () => _confirmDeleteDialog(context, o),
              splashColor: Colors.white,
              child: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
        Divider(color: Theme.of(context).accentColor, thickness: 1, height: 12),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: altView ? _buildAlt() : _buildDefault(),
          ),
        ),
        const SizedBox(height: 12)
      ],
    );
  }

  Row _buildDefault() {
    return Row(children: [
      // Main clothing layer
      _outfitListItem(o.layers.first, o, pad: false),
      const SizedBox(width: 4),
      Expanded(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  //Secondary clothing layer if there is one.
                  o.layers.length > 1
                      ? Expanded(child: _outfitListItem(o.layers[1], o))
                      : const SizedBox(),
                  // Display pants
                  Expanded(child: _outfitListItem(o.pants, o, pad: false))
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  // Display single accessory if there is one.
                  o.accessories.length > 0
                      ? Expanded(child: _outfitListItem(o.accessories.first, o))
                      : const SizedBox(),
                  // Display shoes.
                  Expanded(child: _outfitListItem(o.shoes, o, pad: false)),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildAlt() {
    return Scrollbar(
      radius: Radius.circular(12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (Item layer in o.layers) _outfitListItem(layer, o),
          _outfitListItem(o.pants, o),
          _outfitListItem(o.shoes, o),
          for (Item acc in o.accessories) _outfitListItem(acc, o)
        ],
      ),
    );
  }

  Widget _outfitListItem(Item i, Outfit o, {bool pad = true}) {
    return Padding(
      padding: EdgeInsets.only(right: pad ? 4.0 : 0),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridItemWidget(
          item: i,
          outfit: o,
          showName: false,
        ),
      ),
    );
  }
}
