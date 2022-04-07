import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatelessWidget {
  //This value is assigned when the splash screen is called
  int duration = 0;

  //indicates the page followed by the splash screen
  Widget goToPage;

  Splash_Screen({required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    Future.delayed(Duration(seconds: this.duration), () async {
      // initialize the firebase
      FirebaseApp app = await Firebase.initializeApp();

      //This is used to navigate to the Login Screen immedialtely after
      //The Splash Screen has Been Displayed for the appropriate durtaion
      Navigator.push(
          (context), MaterialPageRoute(builder: (context) => this.goToPage));
    });

    //The following is the layout of the splash screen
    //It contains the app logo
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset("assets/logo.png", fit: BoxFit.contain),
      ),
    );
  }
}
