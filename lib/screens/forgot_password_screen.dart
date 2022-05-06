import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swap_shop/screens/login_screen.dart';

import 'home_screen.dart';
import 'main_navigation_drawer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //form key
  //used to validate email
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    //email field
    //validation : must be filled in
    //validation : must be valid

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email";
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //reset button
    //on Pressed:call verifyEmail()
    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          verifyEmail();
        },
        child: Text(
          "Reset",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
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
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
                child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    emailField,
                    SizedBox(
                      height: 30,
                    ),
                    resetButton,
                    SizedBox(
                      height: 15,
                    ),
                  ]),
            ),
          ),
        ))));
  }

  //verifyEmail method
  //this method will send the email
  //to the Firebase database and check if the email exits
  //if the email does not exist
  //an error is displayed in the snack bar
  //saying that there is no user with that email in the records
  //if the email address exists then an email is sent to that address
  //with a link the user must click to reset their password
  Future verifyEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        showSnackBar(
            "Password Reset Email Has Been Sent", Duration(seconds: 3));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        showSnackBar(e.message.toString(), Duration(seconds: 3));
      }
    }
  }

  // snack bar method for displaying errors
  //when the entered email does not exist in our records
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
        content: Text(snackText), duration: d, backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
