import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/userlists_view.dart';

import 'main_navigation_drawer.dart';

class YourLists extends StatefulWidget {
  const YourLists({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _YourLists();
}

class _YourLists extends State<YourLists> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  final String? uids = FirebaseAuth.instance.currentUser?.uid;
  UserListingModel userListing = UserListingModel();
  int curr = 2;
  List listings = [];
  List yourlistings = [];
  // CollectionReference lists = FirebaseFirestore.instance.collection('listings');

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Listings"),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
          ],
        ),
        drawer: Drawer(
          child: MainNavigationDrawer(),
        ),
        body: FutureBuilder(
          future: FireStoreDataBase().getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              yourlistings = snapshot.data as List;
              //select only listings posted by the user
              for (int i = 0; i < yourlistings.length; i += 1) {
                if (uids == yourlistings[i]['uid'].toString()) {
                  print(listings.length);
                  print(yourlistings[i]['uid'].toString());
                  listings.add(yourlistings[i]);
                  print(i);
                }
              }

              return Scaffold(
                  body: Center(
                child: ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(listings[index]['imageURL'])),
                        title: Text(listings[index]['itemName']),
                        subtitle: Text(listings[index]['description']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Viewlist(
                                        description: listings[index]
                                            ['description'],
                                        listingProvince: listings[index]
                                            ['listingProvince'],
                                        listingCity: listings[index]
                                            ['listingCity'],
                                        itemName: listings[index]['itemName'],
                                        productImage: listings[index]
                                            ['imageURL'],
                                        subCategories: listings[index]
                                            ['subCategories'],
                                        timeStamp: listings[index]
                                            ['listingTime'],
                                        category: listings[index]['category'],
                                        listingID: listings[index]['listingID'],
                                      )));
                        },
                      );
                    }),
              ));
            }

            return Text("loading");
          },
        ));
  }
}
