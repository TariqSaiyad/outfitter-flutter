import 'package:flutter/material.dart';

class ItemsScreen extends StatefulWidget {
  ItemsScreen({this.type});

  final dynamic type;

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Text(widget.type['name']),
      ),
    );
  }
}
