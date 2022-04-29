import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreDataBase {
  List listings = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("Listing");

  Future getData() async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          listings.add(result.data());
        }
      });

      return listings;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }
}
