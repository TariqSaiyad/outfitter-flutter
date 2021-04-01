import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/widgets/add_outfit_screen_layout.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:Outfitter/widgets/selection_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AddOutfitScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const AddOutfitScreen({Key key, this.analytics}) : super(key: key);

  @override
  _AddOutfitScreenState createState() => _AddOutfitScreenState();
}

class _AddOutfitScreenState extends State<AddOutfitScreen> {
  PageController controller;
  final _key = GlobalKey<ScaffoldState>();
  List<Item> items;
  int current = 0;
  String name = "";
  List<Item> selectedLayers = [];
  List<Item> selectedAcc = [];
  Item selectedLegwear;
  Item selectedShoes;

  @override
  void initState() {
    super.initState();
    items = HiveHelpers.getAllItems();
    controller = PageController(initialPage: current);
    controller.addListener(() {
      setState(() {
        current = controller.page.floor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          AddOutfitScreenLayout(
            title: "Give your outfit a name",
            subtitle: "Hint: Keep it short and easy to remember",
            pageIndex: current,
            hasBackButton: true,
            rightFn: name != ""
                ? () {
                    goToNext();
                    FocusScope.of(context).unfocus();
                  }
                : null,
            widget: _nameInput(),
          ),
          AddOutfitScreenLayout(
            title: "Select some layers",
            pageIndex: current,
            subtitle: "Hint: You can select 1-$MAX_LAYERS of these",
            leftFn: goToPrevious,
            rightFn: selectedLayers.isEmpty ? null : goToNext,
            widget: SelectionWidget(
              items: items,
              list: LAYERS_LIST,
              onTap: addOrRemoveLayer,
              test: (Item i) => selectedLayers.contains(i),
            ),
          ),
          AddOutfitScreenLayout(
            title: "Select legwear",
            pageIndex: current,
            leftFn: goToPrevious,
            rightFn: selectedLegwear == null ? null : goToNext,
            widget: SelectionWidget(
              items: items,
              list: LEGWEAR_LIST,
              onTap: (Item i) => setState(() => selectedLegwear = i),
              test: (Item i) => selectedLegwear == i,
            ),
          ),
          AddOutfitScreenLayout(
            title: "Select footwear",
            pageIndex: current,
            leftFn: goToPrevious,
            rightFn: selectedShoes == null ? null : goToNext,
            widget: SelectionWidget(
                items: items,
                list: ['Shoes'],
                onTap: (Item i) => setState(() => selectedShoes = i),
                test: (Item i) => selectedShoes == i,
                withAppbar: false),
          ),
          AddOutfitScreenLayout(
            title: "Select some accessories",
            subtitle:
                "Almost there. Hint: You can select 0-$MAX_ACCESSORIES of these",
            pageIndex: current,
            leftFn: goToPrevious,
            rightFn: saveOutfit,
            rightIcon: const Icon(Icons.check),
            rightCol: Colors.green,
            widget: SelectionWidget(
              items: items,
              list: ['Accessories'],
              onTap: addOrRemoveAcc,
              test: (Item i) => selectedAcc.contains(i),
              withAppbar: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryGrid(String cat) {
    var tmp = HiveHelpers.getItemsInCategory(cat);

    if (tmp.isEmpty) return SizedBox(height: 16);
    return Expanded(
      child: GridView.builder(
          itemCount: tmp.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            var i = tmp[index];
            if (cat != i.category) return const SizedBox();
            return GridItemWidget(item: i);
          }),
    );
  }

  Widget _nameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
      child: TextFormField(
        initialValue: name,
        textAlign: TextAlign.center,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            isDense: false,
            errorStyle: TextStyle(
              color: Colors.red[100],
            ),
            labelText: "Outfit Name",
            hintText: "eg. Formal 1"),
        validator: (value) =>
            value.isEmpty ? 'Outfit name can\'t be empty' : null,
        onChanged: (value) => setState(() => name = value.trim()),
      ),
    );
  }

  /// Add item to list if its not there.
  /// If item exists, remove from list.
  void addOrRemoveLayer(Item i) {
    //if contains item, remove.
    if (selectedLayers.contains(i)) {
      setState(() => selectedLayers.remove(i));
      return;
    }
    // check if limit reached.
    if (selectedLayers.length == MAX_LAYERS) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Cannot add more than $MAX_LAYERS layers',
            textAlign: TextAlign.center,
          )));
      return;
    }
    //else, add item return.
    setState(() => selectedLayers.add(i));
    return;
  }

  void addOrRemoveAcc(Item i) {
    //if contains item, remove.
    if (selectedAcc.contains(i)) {
      setState(() => selectedAcc.remove(i));
      return;
    }
    // check if limit reached.
    if (selectedAcc.length == MAX_ACCESSORIES) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Cannot add more than $MAX_ACCESSORIES layers',
            textAlign: TextAlign.center,
          )));
      return;
    }
    //else, add item return.
    setState(() => selectedAcc.add(i));
    return;
  }

  void goToNext() => animateToPage(current + 1);

  void goToPrevious() => animateToPage(current - 1);

  Future<void> animateToPage(int page) {
    return controller.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void saveOutfit() {
    //create outfit and save.
    var o = Outfit(
        name, selectedAcc, selectedLayers, selectedLegwear, selectedShoes);
    HiveHelpers.addOutfit(o);
    //log event
    widget.analytics.logEvent(name: 'add_outfit_event');
    //go back to outfit page.
    Navigator.pop(context);
  }
}
