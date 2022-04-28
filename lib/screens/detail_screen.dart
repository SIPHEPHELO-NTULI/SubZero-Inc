import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/models/database_manager.dart';
import 'package:swap_shop/models/user_listing_model.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/create_listing.dart';
import 'package:swap_shop/screens/detail_screen.dart';
import 'package:swap_shop/screens/home_screen.dart';
//   "flutter upgrade" to upgrade flutter


class DetailsScreen extends StatelessWidget{
  final String description;
  final String itemName;
  final String productImage;
  final String subCategories;

  const DetailsScreen({
    Key? key,
    required this.description,
    required this.itemName,
    required this.productImage,
    required this.subCategories
 }) :  super(key: key);
  


  @override
 

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        //title: Text(userName),
        backgroundColor: Colors.orange,
        elevation:0.0,
        iconTheme: IconThemeData(
          opacity:20,
          color: Colors.black
          ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.only(

                    bottomLeft: Radius.circular(40),

                    bottomRight: Radius.circular(40),
                  ),
                  
                  image: new DecorationImage(
                    image : NetworkImage( productImage),
                    fit: BoxFit.cover,
                    
                    
                    ) )
                
              ),
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListTile(
                  
                  title: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(itemName,
                    style: TextStyle(
                    fontSize:20,
                    fontWeight: FontWeight.bold
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       Text(
                         subCategories,       //subject to change
                      style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.w600
                      ),
                   ),
                   Container(
                     height: 40,
                     width: 90,
                     decoration: BoxDecoration(
                       color: Colors.red,
                       borderRadius: BorderRadius.circular(10) ),               
                   )
                    ],
                    ),
                    Text("Description",
                     style: TextStyle(
                       fontSize:20,
                       fontWeight: FontWeight.bold,)
                       ),
                       SizedBox(height: 10,),
                       Text(
                          description,
                       style: TextStyle(
                         fontSize: 16,
                       ),
                       ),
                       
                    
                    ]
                    ),
                )
                ))
          ],
        ),
      )
    );
  }
}