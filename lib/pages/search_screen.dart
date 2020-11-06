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
  String category = "";
  String color = "";
  String type = "";
  String code = "";

  List<String> categoryList = new List();
  List<String> typeList = new List();
  List<String> codeList = new List();
  Map<String, Color> colorList = new Map();

  ScrollController _scrollController;
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()
      ..addListener(() {
        setState(() {
          offset = _scrollController.offset /
              _scrollController.position.maxScrollExtent;
        });
      });
    items = widget.person.items;

    categoryList.addAll([NONE_CONST, ...CATEGORY_LIST]);
    typeList.addAll([NONE_CONST, ...CLOTHING_TYPES]);
    codeList.addAll([NONE_CONST, ...DRESS_CODES]);

    colorList.addEntries([
      {NONE_CONST: Colors.black}.entries.first,
      ...COLORS_LIST.entries
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leading: const SizedBox(),
                expandedHeight: MediaQuery.of(context).size.height * 0.9,
                backgroundColor: Theme.of(context).canvasColor,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(0),
                  centerTitle: true,
                  title: _buildtitle(),
                  background: _itemResults(),
                ),
              ),
              SliverFixedExtentList(itemExtent: 65, delegate: _buildInputs())
            ],
          ),
        ));

//      body: Column(
//        children: [
//          const SizedBox(height: 8),
//          SearchHeader(items: items),
//          Expanded(child: _itemResults()),
//          Expanded(child: _searchInputs(context)),
//        ],
//      ),
    //);
  }

  SliverChildListDelegate _buildInputs() {
    return SliverChildListDelegate([
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
    ]);
  }

  GestureDetector _buildtitle() {
    return GestureDetector(
      onTap: _scrollToTop,
      child: AnimatedOpacity(
        opacity: 1 - offset,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          Icons.keyboard_arrow_up,
          size: 32 * (1 - offset),
        ),
      ),
    );
  }

  Widget _itemResults() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: items.length > 0
            ? Column(
                children: [
                  SearchHeader(items: items),
                  Expanded(
                    child: GridView.builder(
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
                                delay:
                                    Duration(milliseconds: 20 + (20 * index)),
                                duration: const Duration(milliseconds: 200),
                                child: GridItemWidget(item: i, isGrid: true),
                              ));
                        }),
                  ),
                ],
              )
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

//  Widget _searchInputs(BuildContext context) {
//    return Container(
//      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(12),
//          color: Theme.of(context).primaryColor),
//      child: ListView(
//        itemExtent: 65,
//        children: [
//          _nameInput(),
//          InputSwiper(
//            title: "Category",
//            onUpdate: updateCategory,
//            itemList: categoryList,
//          ),
//          InputSwiper(
//            title: "Color",
//            onUpdate: updateColor,
//            itemMap: colorList,
//          ),
//          InputSwiper(
//            title: "Dress Code",
//            onUpdate: updateCode,
//            itemList: codeList,
//          ),
//          InputSwiper(
//            title: "Type",
//            onUpdate: updateType,
//            itemList: typeList,
//          ),
//        ],
//      ),
//    );
//  }

  Widget _nameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        cursorColor: Theme.of(context).accentColor,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixText: "Item Name",
          errorStyle: TextStyle(
            color: Colors.red[100],
          ),
          labelText: "Item Name",
          prefixIcon: Icon(Icons.search),
          labelStyle:
              TextStyle(color: Theme.of(context).textTheme.caption.color),
        ),
        onChanged: (val) {
          setState(() {
            query = val;
            filterResults();
          });
        },
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

//  void _scrollToBottom() {
//    _scrollController.animateTo(_scrollController.position.minScrollExtent,
//        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
//  }

  void updateType(int val) {
    setState(() {
      type = typeList[val] == NONE_CONST ? "" : typeList[val];
      filterResults();
    });
  }

  void updateCode(int val) {
    setState(() {
      code = codeList[val] == NONE_CONST ? "" : codeList[val];
      filterResults();
    });
  }

  void updateCategory(int val) {
    setState(() {
      category = categoryList[val] == NONE_CONST ? "" : categoryList[val];
      filterResults();
    });
  }

  void updateColor(int val) {
    setState(() {
      String temp = colorList.keys.toList()[val];
      color = temp == NONE_CONST ? "" : temp;
      filterResults();
    });
  }

  void filterResults() {
    print("$category - $color - $type - $code");
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

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          BackButton(),
          Text(
            "ITEM SEARCH",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w400,
                fontSize: 20),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
            radius: 16,
            child: Text(items.length.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 18)),
          ),
        ],
      ),
    );
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
  int initIndex = 0;

  @override
  void initState() {
    super.initState();
    // get index of last item.
    initIndex = widget.itemList != null
        ? widget.itemList.length - 1
        : widget.itemMap.length - 1;
  }

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
    // reset position when clicked.
    _controller.move(0);
    widget.onUpdate(0);
  }
}
