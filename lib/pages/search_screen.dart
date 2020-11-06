import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const String NONE_CONST = "None";

class SearchScreen extends StatefulWidget {
  final Person person;

  const SearchScreen({Key key, this.person}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Item> items = new List();
  String query = "";
  String category = NONE_CONST;
  String color = NONE_CONST;
  String type = NONE_CONST;
  String code = NONE_CONST;

  List<String> categoryList = new List();
  List<String> typeList = new List();
  List<String> codeList = new List();
  Map<String, Color> colorList = new Map();

  @override
  void initState() {
    super.initState();
    items = widget.person.items;

    categoryList.addAll([...CATEGORY_LIST, NONE_CONST]);
    typeList.addAll([...CLOTHING_TYPES, NONE_CONST]);
    codeList.addAll([...DRESS_CODES, NONE_CONST]);

    colorList.addEntries([
      ...COLORS_LIST.entries,
      {NONE_CONST: Colors.black}.entries.first
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: 8),
        BackButton(),
        Expanded(child: _itemResults()),
        Expanded(child: _searchInputs(context)),
      ],
    ));
  }

  Widget _itemResults() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: items.length > 0
            ? GridView.builder(
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  Item i = items[index];
                  return AnimationConfiguration.staggeredGrid(
                      columnCount: 2,
                      position: index,
                      child: FadeInAnimation(
                        delay: Duration(milliseconds: 20 + (20 * index)),
                        duration: const Duration(milliseconds: 200),
                        child: GridItemWidget(item: i, isGrid: true),
                      ));
                })
            : Center(
                child: Text(
                  "NO ITEMS",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      letterSpacing: 1.5),
                ),
              ),
      ),
    );
  }

  Widget _searchInputs(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor),
      child: ListView(
        itemExtent: 65,
        children: [
          _nameInput(),
          InputSwiper(
            title: "Category",
            onUpdate: updateCategory,
            itemList: categoryList,
          ),
          InputSwiper(
            title: "Color",
            onUpdate: updateColor,
            itemMap: colorList,
          ),
          InputSwiper(
            title: "Dress Code",
            onUpdate: updateCode,
            itemList: codeList,
          ),
          InputSwiper(
            title: "Type",
            onUpdate: updateType,
            itemList: typeList,
          ),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: BackButton()),
          SizedBox(
            width: 4,
          ),
          Expanded(
              flex: 5,
              child: TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
//                border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(8),
//                ),
                  errorStyle: TextStyle(
                    color: Colors.red[100],
                  ),
                  labelText: "Item Name",
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.caption.color),
                ),
                onChanged: (val) {
                  setState(() {
                    query = val;
                    filterResults();
                  });
                },
              ))
        ],
      ),
    );
  }

  void updateType(int val) {
    setState(() {
      type = typeList[val];
      if (type == NONE_CONST) {
        type = "";
      }
      filterResults();
    });
  }

  void updateCode(int val) {
    setState(() {
      code = codeList[val];
      if (code == NONE_CONST) {
        code = "";
      }
      filterResults();
    });
  }

  void updateCategory(int val) {
    setState(() {
      category = categoryList[val];
      if (category == NONE_CONST) {
        category = "";
      }
      filterResults();
    });
  }

  void updateColor(int val) {
    setState(() {
      color = colorList.keys.toList()[val];
      if (color == NONE_CONST) {
        color = "";
      }
      filterResults();
    });
  }

  void filterResults() {
    //check that there are items to perform search on.
    //this avoid any errors accessing a list that is undefined.

    //filter the items by the different categories.
    // the filters are all '&&' together to compound searches.
    items = widget.person.items
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()) &&
            element.category.toLowerCase().contains(category.toLowerCase()) &&
            element.color.toLowerCase().contains(color.toLowerCase()) &&
            element.dressCode.toLowerCase().contains(code.toLowerCase()) &&
            element.type.toLowerCase().contains(type.toLowerCase()))
        .toList();

//      this.searchItems = this.items.filter((item) => {
//          return item.payload.doc.data().category.toLowerCase().includes(this.categoryInput.toLowerCase()) &&
//          item.payload.doc.data().color.toLowerCase().includes(this.colorInput.toLowerCase()) &&
//          item.payload.doc.data().dressCode.toLowerCase().includes(this.dressCodeInput.toLowerCase()) &&
//          item.payload.doc.data().clothingType.toLowerCase().includes(this.clothingTypeInput.toLowerCase())
//    });
  }
}

class InputSwiper extends StatefulWidget {
  final Function onUpdate;
  final Map<String, dynamic> itemMap;
  final List<String> itemList;
  final String title;

  const InputSwiper(
      {Key key, this.title, this.onUpdate, this.itemMap, this.itemList})
      : super(key: key);

  @override
  _InputSwiperState createState() => _InputSwiperState();
}

class _InputSwiperState extends State<InputSwiper> {
  final SwiperController _controller = new SwiperController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: resetIndex,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 1,
              height: 70,
              color: Theme.of(context).textTheme.caption.color.withOpacity(0.4),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 5,
              child: Swiper(
                  controller: _controller,
                  onTap: (int val) => resetIndex(),
                  fade: 0,
                  scale: 0.1,
                  viewportFraction: 0.45,
                  itemCount: widget.itemList != null
                      ? widget.itemList.length
                      : widget.itemMap.length,
                  scrollDirection: Axis.horizontal,
                  onIndexChanged: (int val) => widget.onUpdate(val),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSwipeItem(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeItem(int index) {
    String c;
    Color col = Colors.transparent;
    Color fontCol;
    if (widget.itemList != null) {
      c = widget.itemList[index];
    } else {
      c = widget.itemMap.keys.toList()[index];
      col = widget.itemMap[c];
      fontCol = col == Colors.white ? Colors.black : null;
      col = c == NONE_CONST ? null : col.withOpacity(0.8);
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration:
            BoxDecoration(color: col, borderRadius: BorderRadius.circular(8)),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            Helper.capitalise(c),
            style: TextStyle(fontSize: 20, color: fontCol),
          ),
        ),
      ),
    );
  }

  void resetIndex() {
    // get index of last item.
    int index = widget.itemList != null
        ? widget.itemList.length - 1
        : widget.itemMap.length - 1;
    // reset position when clicked.
    _controller.move(index);
    widget.onUpdate(index);
  }
}
