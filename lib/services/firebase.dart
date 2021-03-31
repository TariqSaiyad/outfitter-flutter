import 'dart:io';

import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hive/hive.dart';

/// Various methods for firebase firestore operations.
class FirebaseMethods {
  FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// Add an item to the firestore db.
  /// Returns a future of the DocumentReference
  Future addItem(Item item) async {
    var file = File(item.image);
    await firebase_storage.FirebaseStorage.instance
        .ref('${Helper.getItemID(item)}.png')
        .putFile(file);
    return await databaseReference.collection(HiveBoxes.items).add(item.toJson());
  }
}
