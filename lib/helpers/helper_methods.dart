import 'dart:io';

import 'package:Outfitter/models/person.dart';
import 'package:flutter/material.dart';

class Helper {
  /// Get the current timestamp in milliseconds.
  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// Delete the specified file from the device.
  static Future<bool> deleteFile(String path) async {
    if (path == null) {
      print("PATH is null");
      return false;
    }
    try {
      final file = File(path);
      await file.delete();
      print("File DELETED");
      return true;
    } catch (e) {
      print("FILE NOT DELETED");
      return false;
    }
  }

  /// Gets the number of items saved in a particular category.
  @deprecated
  static String itemCount(dynamic type, Person p) {
    if (p == null) return "!";
    return p.items
        .where((element) =>
            element.category.toLowerCase() ==
            type['name'].toString().toLowerCase())
        .toList()
        .length
        .toString();
  }

  static Color getComplement(Color primary) {
    return ThemeData.estimateBrightnessForColor(primary) == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static String capitalise(String s) {
    return "${s[0].toUpperCase()}${s.substring(1)}";
  }
}
