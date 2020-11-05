import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/widgets/grid_item_widget.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  final Function removeItemFn;

  const ItemDetailScreen({Key key, this.item, this.removeItemFn})
      : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ScrollController _scrollController;
  double offset = 0.0;
  Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    _scrollController = new ScrollController()
      ..addListener(() {
        setState(() {
          offset = _scrollController.offset /
              _scrollController.position.maxScrollExtent;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height,
            leading: BackButton(color: item.materialColor),
            backgroundColor: Theme.of(context).canvasColor,
            actions: [
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeItem(),
                  color: item.materialColor),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: GestureDetector(
                onTap: _scrollToTop,
                child: SliverItemTitle(offset: offset, item: item),
              ),
              background: GridItemWidget(item: item, isGrid: false),
            ),
          ),
          SliverFixedExtentList(
              itemExtent: 70,
              delegate: SliverChildListDelegate([
                ItemDetail(attribute: "Category", value: item.category),
                ItemDetail(attribute: "Color", child: _buildColorBox()),
                ItemDetail(attribute: "Dress Code", value: item.dressCode),
                ItemDetail(attribute: "Clothing Type", value: item.type),
              ]))
        ],
      ),
    ));
  }

  Widget _buildColorBox() {
    return Text(Helper.capitalise(item.color),
        style: TextStyle(color: item.materialColor));
  }

  void _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  /// This removes the item from the Person object.
  /// It takes the user back to the previous screen.
  void _removeItem() {
    widget.removeItemFn(item);
    Navigator.pop(context);
  }
}

class ItemDetail extends StatelessWidget {
  const ItemDetail({Key key, @required this.attribute, this.value, this.child})
      : super(key: key);

  final String attribute;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Color bgCol = Theme.of(context).textTheme.headline6.color.withOpacity(0.1);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: bgCol, borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            visualDensity: VisualDensity.standard,
            title: value != null ? Text(value) : child,
            trailing: Text(attribute),
          ),
        ),
      ),
    );
  }
}

class SliverItemTitle extends StatelessWidget {
  const SliverItemTitle({
    Key key,
    @required this.offset,
    @required this.item,
  }) : super(key: key);

  final double offset;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: 1 - offset,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: 32 * (1 - offset),
          ),
        ),
        Text(
          item.name,
          style:
              Theme.of(context).textTheme.headline6.copyWith(letterSpacing: 1),
        ),
        Divider(
          height: 8,
          color: item.materialColor,
          thickness: 2,
          endIndent: 24 * (1 - offset),
          indent: 24 * (1 - offset),
        )
      ],
    );
  }
}
