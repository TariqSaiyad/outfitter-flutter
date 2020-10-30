import 'package:Outfitter/widgets/item_tile.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({this.type});

  final dynamic type;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: const BackButton()),
            ItemTile.display(
              type: widget.type,
            ),
          ],
        ),
      ),
    );
  }
}
