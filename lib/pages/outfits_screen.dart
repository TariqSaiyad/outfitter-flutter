import 'package:flutter/material.dart';

class OutfitScreen extends StatefulWidget {
  OutfitScreen({this.type});

  final dynamic type;

  @override
  _OutfitScreenState createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.deepPurple,
        child: Column(
          children: [
            Text("OUTFITS"),
          ],
        ),
      ),
    );
  }
}
