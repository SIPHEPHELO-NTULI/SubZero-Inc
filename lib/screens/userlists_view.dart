import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/create_listing.dart';
import 'package:swap_shop/screens/details_screen.dart';
import 'package:swap_shop/screens/edit_list.dart';
import 'package:swap_shop/screens/home_screen.dart';
//   "flutter upgrade" to upgrade flutter

class Viewlist extends StatelessWidget {
  final String description;
  final String listingProvince;
  final String listingCity;
  final String itemName;
  final String productImage;
  final String timeStamp;
  final String category;
  final String listingID;
  final List subCategories;

  const Viewlist(
      {Key? key,
      required this.description,
      required this.listingProvince,
      required this.listingCity,
      required this.itemName,
      required this.productImage,
      required this.timeStamp,
      required this.category,
      required this.listingID,
      required this.subCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditList(
                            description: description,
                            listingProvince: listingProvince,
                            listingCity: listingCity,
                            itemName: itemName,
                            productImage: productImage,
                            subCategories: subCategories,
                            timeStamp: timeStamp,
                            category: category,
                            listingID: listingID,
                          )));
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(children: [
        Image.network(productImage,
            height: MediaQuery.of(context).size.height * 0.4,
            fit: BoxFit.cover),
        Expanded(
            child: Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    itemName,
                    style: Theme.of(context).textTheme.headline5,
                  ), //item name display
                ]),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Description : " + description)),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("City : " + listingCity)
                    //style: Theme.of(context).textTheme.headlineSmall),
                    ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Province : " + listingProvince)
                    //style: Theme.of(context).textTheme.headlineSmall),
                    ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Upload Date : " + timeStamp)
                    //style: Theme.of(context).textTheme.headlineSmall),
                    ),
                if ((subCategories[0] == "N/A") == false)
                  Text(subCategories[0]),
              ],
            ),
          ),
        ))
      ]),
    );
  }
}
