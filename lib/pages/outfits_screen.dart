import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/widgets/custom_dialog.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class OutfitScreen extends StatefulWidget {
  OutfitScreen({this.isAltOutfitView});

  final bool isAltOutfitView;

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  List<Outfit> outfits;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    outfits = HiveHelpers.getAllOutfits();
  }

  void onRemove(Outfit o) {
    HiveHelpers.removeOutfit(o);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: outfits.isEmpty
              ? const Center(child: const Text("NO OUTFITS"))
              : Scrollbar(
                  radius: const Radius.circular(8),
                  thickness: 4,
                  child: ListView(
                    itemExtent: (MediaQuery.of(context).size.width / 2) + 8,
                    children: [
                      for (Outfit o in outfits)
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                MaterialButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () => onRemove(o),
                  color: Colors.redAccent,
                  child: const Text("DELETE"),
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
                  o.accessories.isNotEmpty
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
