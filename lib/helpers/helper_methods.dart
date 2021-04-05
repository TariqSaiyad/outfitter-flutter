import 'dart:convert';
import 'dart:io';

import 'package:Outfitter/models/item.dart';
import 'package:flutter/material.dart';

class Helper {
  /// Retrieve the item id based on its properties.
  static String getItemID(Item i) {
    return "${i.name}-${i.category}-${i.color}-${i.type}";
  }

  /// Convert the image file to a base64 representation.
  static String imageToBase64(String filePath) {
    return base64Encode(File(filePath).readAsBytesSync());
  }

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

  static Color getComplement(Color primary) {
    return ThemeData.estimateBrightnessForColor(primary) == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static String capitalise(String s) {
    return "${s[0].toUpperCase()}${s.substring(1)}";
  }
}
