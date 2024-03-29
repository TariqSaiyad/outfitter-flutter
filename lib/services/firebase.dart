import 'dart:io';

import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// Various methods for firebase firestore operations.
class FirebaseMethods {
  FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// Add an item to the firestore db.
  /// Returns a future of the DocumentReference
  Future<DocumentReference> addItem(Item item) async {
    var file = File(item.image);
    await storage.ref('${Helper.getItemID(item)}.png').putFile(file);

    return await databaseReference
        .collection(HiveBoxes.items)
        .add(item.toJson());
  }
}
