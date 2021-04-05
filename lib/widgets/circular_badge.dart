import 'package:Outfitter/constants/styles.dart';
import 'package:flutter/material.dart';

class CircularBadge extends StatelessWidget {
  final String text;

  const CircularBadge({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
      radius: 16,
      child: Text(text, style: Styles.subtitle1),
    );
  }
}
