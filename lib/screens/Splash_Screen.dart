import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  Splash_Screen({required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    Future.delayed(Duration(seconds: this.duration), () async {
      // initialize the firebase
      FirebaseApp app = await Firebase.initializeApp();
      //this is where i fetch data from firebase

      Navigator.push(
          (context), MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
        body: Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
    ));
  }
}
