import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_shop/DatabaseManager/DatabaseManager.dart';
import 'package:swap_shop/models/user_model.dart';
import 'package:swap_shop/screens/home_screen.dart';
import 'package:swap_shop/screens/registration_screen.dart';
import 'package:swap_shop/screens/login_screen.dart';

class DatabaseManager{
  final String name = '';
  final String username = "";
  final String city = '';
  final String email ="";
  final CollectionReference usersList = 
    FirebaseFirestore.instance.collection('users');
    
    
  Future<void> createUserData(
       String username, String city, String email,String name, String uid) async{
    return await usersList
      .doc(uid)
      .set({'username':username, 'city':city, 'email':email, 'name':name
      });
    }


    Future updateUserList(String username, String city, String email,String name, String uid) async{
      return await usersList.doc(uid).update({
        'username':username, 'city':city, 'email':email, 'name':name
      });
    }
    

    Future getUsersList() async{
      List itemsList = [];
      try{
        await usersList.get().then((QuerySnapshot){
          QuerySnapshot.docs.forEach((element){
            itemsList.add(element);
        });
      });
      return itemsList;
    } catch(e){
      print(e.toString());
      return null;
    }
  } 
   
}