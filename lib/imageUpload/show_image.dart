import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  UserListingModel userListing = UserListingModel();
  int curr = 1;
  List listings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items Available For Swapping"),
      ),
      body: FutureBuilder(
        future: FireStoreDataBase().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            listings = snapshot.data as List;
            return buildItems(listings);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildItems(dataList) => ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        String url = dataList[index]['imageURL'];
        return Container(
          height: 350.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: url == null
                ? Placeholder()
                : Image.network(
                    "$url",
                    fit: BoxFit.contain,
                  ),
          ),
        );
      });
}
