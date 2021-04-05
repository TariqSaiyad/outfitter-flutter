import 'package:flutter/material.dart';

class Styles {
  static const title = TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400);

  static const header3 = TextStyle(fontSize: 22, letterSpacing: 1.4);

  static const text16 = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const text18 = TextStyle(fontSize: 18, letterSpacing: 1);

  static const subtitle1 =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18);
  static const subtitle2 = TextStyle(fontWeight: FontWeight.w300, fontSize: 14);

  static const spaced5 = TextStyle(letterSpacing: 5);
  static const spaced2 = TextStyle(letterSpacing: 2);

  static TextStyle textX(double size) {
    return TextStyle(
        color: Colors.white,
        letterSpacing: 4,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }
}
