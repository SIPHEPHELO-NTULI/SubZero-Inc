import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  Splash_Screen({required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
          (context), MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
        body: Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
    ));
  }
}
